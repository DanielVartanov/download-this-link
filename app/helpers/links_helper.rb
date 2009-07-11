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
  end
end