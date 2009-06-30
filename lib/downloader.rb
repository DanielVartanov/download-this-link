require 'curb'

class Downloader
  MAX_DOWNLOAD_SIZE = 100000000

  def initialize(link)
    @link = link
    @curl = Curl::Easy.new
    @curl.url = @link.url
    @curl.follow_location = true

    @curl.on_progress do |dl_total, dl_now, ul_total, ul_now|
      self.on_progress(dl_now, dl_total, @curl.download_speed, @curl.total_time)
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

    @link.status = "downloading"
    @link.file_path = filename
    @link.save!

    @curl.perform
  end

  def on_header(header)
    puts "on_header: #{header}";
  end

  def on_body(data)
    @file.print(data)
  end

  def on_progress(downloaded_size, total_size, download_speed, downloading_time)    
    return if @link.downloading_time.to_i == downloading_time.to_i

    @link.downloading_time = downloading_time.to_i
    @link.download_speed = download_speed
    @link.complete_percentage = downloaded_size.zero? ? 0 : (downloaded_size.to_f / total_size * 100).to_i
    @link.save
  end

  def on_complete
    puts "on_complete"
    @file.close
  end

  def on_success
    @link.status = "downloaded"
    @link.complete_percentage = 100
    @link.save!
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
    link.update_attribute(:file_size, file_size)

    if file_size <= MAX_DOWNLOAD_SIZE
      downloader = Downloader.new(link)      
      downloader.download!
    else
      link.update_attribute.status = "failure"
      link.update_attribute.error_message = "File is too big"
      link.save!
    end

  rescue Exception => e
    link.status = "failure"
    link.error_message = e.to_s
    link.save!
  end
end