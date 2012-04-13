#!/usr/bin/env ruby

require 'rubygems'
require 'fog'
require 'colored'

compute = Fog::Compute.new(
  :provider                 => 'AWS',
  :aws_secret_access_key    => ENV['AWS_SECRET_ACCESS_KEY'],
  :aws_access_key_id        => ENV['AWS_ACCESS_KEY_ID']
)

servers = compute.servers.inject({}) do |acc, current|
  acc[current.id] = (current.tags['Name'] || current.id)
  acc
end

connection = Fog::AWS::ELB.new(
  :aws_secret_access_key    => ENV['AWS_SECRET_ACCESS_KEY'],
  :aws_access_key_id        => ENV['AWS_ACCESS_KEY_ID']
)

class Status < Struct.new(:instance_id, :server, :state, :description)

  def ok?
    state == 'InService'
  end

  def server_name
    "#{server} (#{instance_id})"
  end

end

connection.load_balancers.each do |lb|

  stats = []
  health = connection.describe_instance_health(lb.id)
  health.body['DescribeInstanceHealthResult']['InstanceStates'].each do |instance|
    identifier = instance['InstanceId']
    stats << Status.new(identifier, servers[identifier], instance['State'], instance['Description'])
  end

  max_width = stats.map { |a| a.server_name.length }.max
  healthy = stats.all? { |s| s.ok? }

  puts "#{lb.id}: #{healthy ? "HEALTHY".green : "UNHEALTHY".red}"

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