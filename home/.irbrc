# Require RubyGems by default.
require 'rubygems'

require 'irb/completion'

completion_path = File.expand_path("~/.irb/fixed_save_history.rb")
require completion_path if File.exist?(completion_path)
IRB.conf[:SAVE_HISTORY] = 10000000
IRB.conf[:HISTORY_FILE] = File.expand_path("~/.irb-save-history")

def mate
  require 'tempfile'
  t = ($irb_mate_file ||= Tempfile.new("irb"))
  system "mate", "-w", t.path
  eval File.read(t.path), binding
end

at_exit do
  if defined?($irb_mate_file)
    $irb_mate_file.unlink
  end
end

begin
  require "ap"
  IRB::Irb.class_eval do
    def output_value
      ap @context.last_value
    end
  end
rescue LoadError => e
  require 'pp'
  IRB::Irb.class_eval do
    def output_value
      pp @context.last_value
    end
  end
end

Numeric.class_eval do

  def of(&blk)
    (1..self.to_i).map do
      yield
    end
  end

end

def diff(a, b, file = "current.diff")
  require 'rspec/expectations/differ'
  differ = RSpec::Expectations::Differ.new
  diff = differ.diff_as_object(a, b)
  File.open(file, "w+") { |f| f.write diff }
  system "mate", file
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
    defined?(ActiveRecord) && ActiveRecord::Base.logger = Rails.logger
    defined?(Mongoid)      && Mongoid.logger = Rails.logger
    if defined?(MongoMapper)
      MongoMapper.connection.instance_variable_set :@logger, Rails.logger
    end
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
