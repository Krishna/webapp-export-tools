#!/usr/bin/env ruby -wKU -rubygems
require File.join(File.dirname(__FILE__), 'tumblr_post')
require 'xmlsimple'

def usage
  <<-EOU
Usage: #{$0} <tumblr xml export filename>

Script to create a single markdown text file for each page on a Jottit site.

1. Export the content of your Tumblr site to xml format
2. Run this script against the downloaded file.

The script then creates a file for every tumblr post.

EOU
end



if ARGV.size != 1
  STDERR.puts usage
  exit
end

filename = ARGV[0]
feed = XmlSimple.xml_in(filename)
TumblrPost.make_files_for_posts_from_xml(feed)
