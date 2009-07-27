require 'timeout'
  DW_PROCESS_TIME_OUT = 21600
class DownloadFilesLoop < Loops::Base
  DW_PROCESS_COUNT = 1

  def run
    with_period_of(5) do
      unless queue_is_empty?
        if (Link.downloading.count < DW_PROCESS_COUNT)
          puts "Starting file #{Link.queued.first.inspect}"
          start_download Link.queued.first
        else
          puts "Es gibt process limit."
        end
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
    link.status = "downloading"
    link.save
    Timeout::timeout(DW_PROCESS_TIME_OUT, DownloadTimeoutException) { Downloader.start!(link) }
  rescue Exception => exception
    puts "==== UNHANDLED ERROR: #{exception}"
  end
end

def queue_is_empty?
  Link.queued.count == 0
end