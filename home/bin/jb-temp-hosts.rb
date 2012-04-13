#!/usr/bin/env ruby

require 'rubygems'
require 'fog'

connection = Fog::Compute.new(
  :provider                 => 'AWS',
  :aws_secret_access_key    => ENV['AWS_SECRET_ACCESS_KEY'],
  :aws_access_key_id        => ENV['AWS_ACCESS_KEY_ID']
)

connection.servers.all.each do |host|
  name = host.tags['Name']
  temp = host.tags["Temp"]
  next unless host.state == "running" && (temp or name.nil?)
  puts host.dns_name
end