require 'curb'

class Downloader
  MAX_DOWNLOAD_SIZE = 100000000

  def initialize(link)
    @link = link
    @curl = Curl::Easy.new
    @curl.url = @link.url
    @curl.follow_location = true

    @curl.on_progress do |dl_total, dl_now, ul_total, ul_now|
      puts "on_progress: #{dl_now} of #{dl_total} (#{@curl.download_speed} b/s) #{@curl.total_time}s"
      true
    end

    @curl.on_body { |data| self.on_body(data); data.size }
    @curl.on_header { |data| self.on_header(data); data.size }
    @curl.on_complete { |data| self.on_complete }
    @curl.on_failure { |data| self.on_failure }
    @curl.on_success { |data| self.on_success }
  end

  def download!
    filename = generate_file_name
    @file = File.open(Merb.root / 'public' / 'files' / filename, 'w')

    @link.update_attribute(:status, "downloading")    
    @link.update_attribute(:file_path, filename)
    @curl.perform
  end

  def on_header(header)
    puts "on_header: #{header}";
  end

  def on_body(data)
    @file.print(data)
  end

  def on_complete
    puts "on_complete"
    @file.close
  end

  def on_success    
    @link.update_attribute(:status, "downloaded")
  end

  def on_failure
    @link.update_attribute(:status, "failure")
  end

  def generate_file_name
    "file-#{rand(1000000000)}"
  end

  def self.request_file_size!(url)
    curl = Curl::Easy.new
    curl.url = url
    curl.follow_location = true    
    curl.http_head
    curl.downloaded_content_length
  end

  def self.start!(link)
    file_size = Downloader.request_file_size!(link.url)

    if file_size <= MAX_DOWNLOAD_SIZE
      downloader = Downloader.new(link)      
      downloader.download!
    else
      link.update_attribute(:status, "failure")
      link.update_attribute(:error_message, "File is too big")
    end

  rescue Exception => e
    link.update_attribute(:status, "failure")
      link.update_attribute(:error_message, e.to_s)
  end
end