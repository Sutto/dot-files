require 'fileutils'

def fix_all!(entries)
  entries.each do |file|
    next unless file =~ /\S\-\s/
    new_file = file.gsub(/(\S)\-\s/, '\1 - ')
    system "mv", file, new_file
  end
end

fix_all! Dir["*"].select { |i| File.directory?(i) }
fix_all! Dir["**/*"]
