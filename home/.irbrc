# Require RubyGems by default.
require 'rubygems'

require 'irb/completion'

completion_path = File.expand_path("~/.irb/fixed_save_history.rb")
require completion_path if File.exist?(completion_path)
IRB.conf[:SAVE_HISTORY] = 10000000
IRB.conf[:HISTORY_FILE] = File.expand_path("~/.irb-save-history")
 
# Require UtilityBelt for lots of functionality
# http://utilitybelt.rubyforge.org/
begin
  require 'utility_belt'
  UtilityBelt::Equipper.equip(:defaults)
  UtilityBelt::Equipper.equip(:with, :string_to_proc, :pipe, :not,
                              :language_greps, :is_an, :clipboard,
                              :interactive_editor)
rescue LoadError
end
 
# Require PrettyPrint cuz it pwns...how did I not know about this?
require 'pp'
 
# Benchmarking
require 'benchmark'
def bench(n=1e3,&b)
  Benchmark.bmbm do |r|
    r.report {n.to_i.times(&b)}
  end
end
 
class Object
  def local_methods(obj = self)
    (obj.methods - obj.class.superclass.instance_methods).sort
  end
end
 
# Use the simple prompt if possible.
IRB.conf[:PROMPT_MODE] = :SIMPLE if IRB.conf[:PROMPT_MODE] == :DEFAULT
 
if ENV['RAILS_ENV'] || defined?(Rails)
   
  def sql(query) 
    ActiveRecord::Base.connection.select_all(query) 
  end
   
  require 'logger' 
  if defined?(Rails) && Rails.respond_to?(:logger=)
    Rails.logger = Logger.new(STDOUT)
    ActiveRecord::Base.logger = Rails.logger
  else
    Object.const_set(:RAILS_DEFAULT_LOGGER, Logger.new(STDOUT))
  end
   
  def loud_logger 
    set_logger_to Logger.new(STDOUT) 
  end
   
  def quiet_logger 
    set_logger_to nil 
  end
   
  def set_logger_to(logger) 
    ActiveRecord::Base.logger = logger 
    ActiveRecord::Base.clear_active_connections! 
  end
else
  UtilityBelt::Equipper.equip(:symbol_to_proc) if defined?(UtilityBelt::Equipper)
end

def ring_server(force = false)
  if force || @__rs.nil?
    require 'rinda/ring'
    DRb.start_service
    @__rs = Rinda::RingFinger.primary
  end
  return @__rs
  rescue RuntimeError
    @__rs = nil
    return nil
end

def say(text)
  system "say", text.to_s
end

def growl(msg, title = "hallo thar!", sticky = false)
  args = ["growlnotify", "-n", "irb", "-m", msg, title]
  args << "-s" if sticky
  system(*args)
end

def notify
  if block_given?
    yield
    growl "I'm done", "notify via irb", true
    say "Done!"
  else
    say "Give me a block, dumb ass."
  end
end

proc do
  path = File.join(Dir.pwd, ".irb")
  load(path) if File.file?(path)
end.call

if defined?(Rails)
  
  def rr
    if Rails::VERSION::STRING >= "3.0.0"
      puts "Reloading..."
      ActionDispatch::Callbacks.new(lambda {}, false).call({})
    else
      reload!
    end
  end
  
end
