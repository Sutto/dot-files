#!/usr/bin/env ruby
require 'rubygems'
require 'fastimage'

url = ARGV.first

if url.nil?
  $stderr.puts "Useage: $0 url"
  exit 1
end

image = FastImage.new(url)

puts "Size: #{image.size.join('x')}"
puts "Type: #{image.type}"