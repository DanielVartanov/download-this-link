class DownloadFilesLoop < Loops::Base
  def run
    with_period_of(5) do
      puts "Hello, loop!"
      unless queue_is_empty?
        puts "Starting file #{Link.queued.first.inspect}"
        start_download Link.queued.first
      else
        puts "No files in queue..."
      end
    end
  end
end

def start_download(link)
  link.update_attribute(:status, "downloading")
  file_name = generate_file_name
  download_link(link.url, Merb.root / 'public' / 'files' / file_name)
  link.update_attribute(:file_path, file_name)
  link.update_attribute(:status, "downloaded")
end

def download_link(url, file_name)
  rio(url) > rio(file_name)
end

def generate_file_name
  "file-#{rand(1000000000)}"
end

def queue_is_empty?
  Link.queued.count == 0
end