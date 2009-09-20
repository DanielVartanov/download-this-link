module Merb
  module LinksHelper
    MINUTE = 60
    HOUR = 60 * MINUTE

    def display_downloading_time(seconds)      
      hours = seconds / HOUR
      minutes = seconds.modulo(HOUR) / 60
      seconds = seconds - hours * HOUR - minutes * MINUTE
      "%02d:%02d:%02d" % [hours, minutes, seconds]
    end

    def is_media_file(file_path)
      tmp = File.extname(file_path).downcase
      return true if (tmp == ".mp3")
      return true if (tmp == ".wav")
      return true if (tmp == ".mdi")
      return false
    end

    def is_video_file(file_path)
      tmp = File.extname(file_path).downcase
      return true if (tmp == ".avi")
      return true if (tmp == ".mp4")
      return true if (tmp == ".rm")
      return true if (tmp == ".rmvb")
      return true if (tmp == ".mov")
      return true if (tmp == ".mpg")
      return true if (tmp == ".mpeg")
      return true if (tmp == ".mkv")
      return true if (tmp == ".mka")
      return true if (tmp == ".ogm")
      return true if (tmp == ".3gp")
      return true if (tmp == ".flv")
      return false
    end

  end
end