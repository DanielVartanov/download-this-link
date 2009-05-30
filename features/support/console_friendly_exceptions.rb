module Merb
  module ConsoleFriendlyExceptions
    class << self
      def setup!
        this = self
        cls = Class.new(Merb::Dispatcher::DefaultException) do
          include this
          class << self
            def name
              "Merb::Dispatcher::DefaultException"
            end
            alias_method :to_s, :name
          end
        end
      
        Merb::Dispatcher.module_eval do 
          remove_const(:DefaultException)
          const_set(:DefaultException, cls)
        end
      end
    end # class << self
  
    def index
      @exceptions = request.exceptions
      out = []
      
      if @exceptions.size > 1
        out << h1("Error Stack")
        @exceptions.each_with_index do |exception, i| 
          out << "  " + humanize_exception(exception)
          out << "    " + exception.message.split("\n",2).first.to_s
        end
      end
      
      @exceptions.each_with_index do |exception,i| 
        out << h1(humanize_exception(exception) + " [#{exception.class.status}]")
        out << error_codes(exception)
        
        out << "_"*80 << " "
        
        exception.backtrace.each_with_index do |line, index|
          type, shortname, filename, lineno, location = frame_details(line)
          prefix = (type == "app" ? "  " : " "*60)
          unless shortname.to_s[/cucumber|webrat/]
            out << %{#{prefix}#{shortname}:#{lineno}}
          end
        end
      end
      
      out << "_"*80 << " "
      
      out << h1("Parameters")
      out << listing(request.params)
      if request.session?
        out << h1("Session")
        out << listing(request.session)
      end 
      out << h1("Cookies")
      out << listing(request.cookies)
      
      out << "_"*80
      
      out.join("\n")
    end
    
  protected
  
    def h1(str)
      "==== #{str}"
    end
    
    def humanize_exception(e)
      e.class.name.split("::").last.gsub(/([a-z])([A-Z])/, '\1 \2')
    end
    
    def error_codes(exception)
      message, message_details = exception.message.split("\n", 2)
      [ "  #{message}",
        "    #{message_details}"
      ].join("\n")
    end
    
    def listing(arr = [])
      ret = []
      (arr || []).each_with_index do |(key, val), i|
        ret << "  #{key.inspect} => #{val.inspect}"
      end
      if arr.blank?
        ret << "  None"
      end
      ret.join("\n")
    end
    
  end
end
