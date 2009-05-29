require 'yaml'

class Loops
  cattr_reader :config
  cattr_reader :loops_config
  cattr_reader :global_config
  
  def self.load_config(file)
    @@config = YAML.load_file(file)
    @@global_config = @@config['global']
    @@loops_config = @@config['loops']
    
    @@logger = create_logger('global', global_config)
  end
  
  def self.start_loops!(loops_to_start = :all)
    @@running_loops = []
    @@pm = Loops::ProcessManager.new(global_config, @@logger)
    
    # Start all loops
    loops_config.each do |name, config|
      next if config['disabled']
      next unless loops_to_start == :all || loops_to_start.member?(name)
      klass = load_loop_class(name)
      next unless klass

      start_loop(name, klass, config) 
      @@running_loops << name
    end
    
    # Do not continue if there is nothing to run
    if @@running_loops.empty?
      puts "WARNING: No loops to run! Exiting..."
      return
    end

    # Start monitoring loop
    setup_signals
    @@pm.monitor_workers

    info "Loops are stopped now!"
  end

private

  # Proxy logger calls to the default loops logger
  [ :debug, :error, :fatal, :info, :warn ].each do |meth_name|
    class_eval <<-EVAL
      def self.#{meth_name}(message)
        LOOPS_DEFAULT_LOGGER.#{meth_name} "\#{Time.now}: loops[RUNNER/\#{Process.pid}]: \#{message}"
      end
    EVAL
  end

  def self.load_loop_class(name)
    begin
      klass_file = LOOPS_ROOT + "/app/loops/#{name}_loop.rb" 
      debug "Loading class file: #{klass_file}"
      require(klass_file)
    rescue Exception
      error "Can't load the class file: #{klass_file}. Worker #{name} won't be started!"
      return false
    end
    
    klass_name = "#{name}_loop".classify
    klass = klass_name.constantize rescue nil
    
    unless klass
      error "Can't find class: #{klass_name}. Worker #{name} won't be started!"
      return false
    end

    begin
      klass.check_dependencies
    rescue Exception => e
      error "Loop #{name} dependencies check failed: #{e} at #{e.backtrace.first}"
      return false
    end

    return klass
  end
  
  def self.start_loop(name, klass, config)
    puts "Starting loop: #{name}"
    info "Starting loop: #{name}"
    info " - config: #{config.inspect}"
    
    @@pm.start_workers(name, config['workers_number'] || 1) do
      debug "Instantiating class: #{klass}"
      looop = klass.new(create_logger(name, config))
      looop.name = name
      looop.config = config
      
      debug "Starting the loop #{name}!"
      fix_ar_after_fork
      looop.run
    end
  end

  # TODO: Need to add logs rotation parameters
  def self.create_logger(loop_name, config)
    config['logger'] ||= 'default'

    return LOOPS_DEFAULT_LOGGER if config['logger'] == 'default'
    return Logger.new(STDOUT) if config['logger'] == 'stdout'
    return Logger.new(STDERR) if config['logger'] == 'stderr'
    
    config['logger'] = File.join(LOOPS_ROOT, config['logger']) unless config['logger'] =~ /^\//
    Logger.new(config['logger'])

  rescue Exception => e
    message = "Can't create a logger for the #{loop_name} loop! Will log to the default logger!"
    puts "ERROR: #{message}"

    message << "\nException: #{e} at #{e.backtrace.first}"
    error(message)

    return LOOPS_DEFAULT_LOGGER
  end

  def self.setup_signals
    trap('TERM') {
      warn "Received a TERM signal... stopping..."
      @@pm.stop_workers!
    }

    trap('INT') { 
      warn "Received an INT signal... stopping..."
      @@pm.stop_workers!
    }

    trap('EXIT') { 
      warn "Received a EXIT 'signal'... stopping..."
      @@pm.stop_workers!
    }
  end
  
  def self.fix_ar_after_fork
    ActiveRecord::Base.allow_concurrency = true
    ActiveRecord::Base.clear_active_connections!
    ActiveRecord::Base.verify_active_connections!
  end
end

require 'loops/process_manager'
require 'loops/base'
require 'loops/queue'
