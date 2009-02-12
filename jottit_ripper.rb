#!/usr/bin/env ruby -wKU -rubygems
require 'xmlsimple'

def usage
  <<-EOU
Usage: #{$0} <atom filename>

Script to create a single markdown text file for each page on a Jottit site.

1. Export the content of your Jottit site to Atom Syndication Format (found on the settings page).
2. Run this script against the downloaded file.

Creates a file for every entry in the atom file.
Each file is named after the title element in the atom feed and given a '.md.txt' suffix.

EOU
end


def create_file(title, contents)
  filename = title + ".md.txt"
  filename.gsub!('/', ' or ')

  File.open(filename, "w") do |file|
    file.puts contents
  end    
end

if ARGV.size != 1
  STDERR.puts usage
  exit
end


filename = ARGV[0]

atom = XmlSimple.xml_in(filename)

atom["entry"].each do |entry|
  title = entry['title'][0]
  content = entry["content"]["content"]

  puts "processing:#{title}"
  create_file(title, content)
end