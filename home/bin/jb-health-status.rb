#!/usr/bin/env ruby

require 'rubygems'
require 'fog'
require 'colored'

config = {aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'], aws_access_key_id: ENV['AWS_ACCESS_KEY_ID']}

compute = Fog::Compute.new config.merge(provider: 'AWS')

servers = []

class Server < Struct.new(:name, :id, :state, :dns_name, :flavor_id, :state_reason)

  def ok?
    state == 'running'
  end

  def display_name(width)
    status_colour = ok? ? :green : :red
    if name == id
      id.ljust(width + 4 + id.length)
    else
      "#{name.ljust(width).send(status_colour)} (#{id.yellow})"
    end
  end

end

server_status = []
servers = compute.servers.inject({}) do |acc, current|
  server_name = (current.tags['Name'] || current.id)
  acc[current.id] = server_name
  server_status << Server.new(server_name, current.id, current.state, current.dns_name, current.flavor_id)
  acc
end

puts "Servers:".blue

max_width = server_status.map { |s| s.name.length }.max
server_status.sort_by(&:name).each do |server|
  name = server.display_name max_width
  if server.ok?
    puts "#{name} - #{server.state.green}"
  else
    puts "#{name} - #{server.state.red} #{server.state_reason.inspect.yellow}"
  end
end

puts ""

elb = Fog::AWS::ELB.new(config)

class Status < Struct.new(:instance_id, :server, :state, :description)

  def ok?
    state == 'InService'
  end

  def server_name
    "#{server} (#{instance_id})"
  end

end

puts "Load Balancers:".blue

elb.load_balancers.each do |lb|

  stats = []
  health = elb.describe_instance_health(lb.id)
  health.body['DescribeInstanceHealthResult']['InstanceStates'].each do |instance|
    identifier = instance['InstanceId']
    stats << Status.new(identifier, servers[identifier], instance['State'], instance['Description'])
  end

  max_width = stats.map { |a| a.server_name.length }.max
  healthy = stats.all? { |s| s.ok? }

  puts "#{lb.id.bold}: #{healthy ? "HEALTHY".green : "UNHEALTHY".red}"

  stats.each do |status|
    name = status.server_name.ljust(max_width)
    if status.ok?
      puts "#{name.green} - A-OK!"
    else
      puts "#{name.red} - #{status.description.yellow}"
    end
  end

  puts ""

end

class Cluster < Struct.new(:id, :status, :node_type, :engine, :nodes)

  def ok?
    status == 'available'
  end

end

class CacheNode < Struct.new(:id, :status, :address, :port)

  def ok?
    status == 'available'
  end

  def display_name
    id.to_s
  end

  def to_address
    "#{address}:#{port}"
  end

end

elasticache = Fog::AWS::Elasticache.new(config)

puts "Cache Instances:".blue

clusters = []
elasticache.clusters.all.each do |cluster|
  ours = Cluster.new cluster.id, cluster.status, cluster.node_type, cluster.engine, []
  cluster.nodes.each do |node|
    ours.nodes << CacheNode.new(node['CacheNodeId'], node['CacheNodeStatus'], node['Address'], node['Port'])
  end
  clusters << ours
end

clusters.each do |cluster|
  nodes = cluster.nodes
  max_width = nodes.map { |a| a.display_name.length }.max
  healthy   = nodes.all? { |s| s.ok? }

  actual_status = cluster.ok? ? "(#{cluster.status})".green : "(#{cluster.status})".red
  puts "#{cluster.id.bold}: #{healthy ? "HEALTHY".green : "UNHEALTHY".red} #{actual_status}\n#{cluster.node_type.yellow} running #{cluster.engine.yellow}"
  nodes.each do |node|
    name = node.display_name.ljust max_width
    if node.ok?
      puts "#{name.green} - A-OK!"
    else
      puts "#{name.red} - #{node.status.yellow}"
    end
  end
  puts ""
end

rds = Fog::AWS::RDS.new(
  :aws_secret_access_key    => ENV['AWS_SECRET_ACCESS_KEY'],
  :aws_access_key_id        => ENV['AWS_ACCESS_KEY_ID']
)

class Database < Struct.new(:id, :name, :state, :engine, :type)

  def ok?
    state == 'available'
  end

  def display_name
    id.strip
  end

end

dbs = rds.servers.all.map do |db|
  Database.new db.id, db.db_name, db.state, db.engine, db.flavor_id
end

puts "Database:".blue
max_width = dbs.map { |db| db.display_name.length }.max
dbs.each do |db|
  name = db.display_name.ljust max_width
  if db.ok?
    puts "#{name.green} - A-OK!"
  else
    puts "#{name.red} - #{db.state.red}"
  end
end
puts ""