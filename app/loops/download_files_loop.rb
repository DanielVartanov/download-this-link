require 'timeout'

class DownloadFilesLoop < Loops::Base
  def run
    with_period_of(5) do      
      unless queue_is_empty?
        puts "Starting file #{Link.queued.first.inspect}"
        start_download Link.queued.first
      else
        print '.'
      end
    end
  end
end

class DownloadTimeoutException < Exception ; end

class DownloadersDispatcher
  
end

def start_download(link)
  pid = fork { downloader_process(link) }
  Process.detach(pid)
end

def downloader_process(link)
  begin
    Timeout::timeout(600, DownloadTimeoutException) { Downloader.start!(link) }
  rescue DownloadTimeoutException => exception
    puts "==== UNHANDLED ERROR: #{exception}"
  end
end

def queue_is_empty?
  Link.queued.count == 0
end