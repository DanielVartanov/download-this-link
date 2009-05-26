#!/usr/bin/env ruby

require "merb-core"
Merb.start_environment(:environment => ENV['MERB_ENV'] || 'development')

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

loop do
  if Link.queued.count > 0
    start_download Link.queued.first
  end

  sleep 1
end