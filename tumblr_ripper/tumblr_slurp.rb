#!/usr/bin/env ruby -wKU -rubygems
require File.join(File.dirname(__FILE__), 'tumblr_post')
require 'xmlsimple'

def usage
  <<-EOU
Usage: #{$0} <tumblr website url> <starting post number> <number of posts to pull down>

Script to pull down the contents of a tumblr site.

EOU
end


def read_url(site_url, start, number)
  if site_url.index("http://") == nil
    return "http://#{site_url}/api/read?filter=none&start=#{start}num=#{number}"
  end
  "#{site_url}/api/read?filter=none&start=#{start}num=#{number}"
end

def fetch_with_curl(url)
  cmdLine = "curl \"#{url}\""
  `#{cmdLine}`  
end

MAX_SUPPORTED_POSTS = 50

site_url = ARGV[0]
start    = ARGV[1].to_i || 0 
number_to_fetch   = ARGV[2].to_i || MAX_SUPPORTED_POSTS

full_fetches = number_to_fetch / MAX_SUPPORTED_POSTS
remaining = number_to_fetch % MAX_SUPPORTED_POSTS

batches = []
1.upto(full_fetches) do |i|
  batches << MAX_SUPPORTED_POSTS
end
batches << remaining if remaining > 0
  
#puts batches.inspect


batches.each do |number|
  # puts "-- start:#{start} | number: #{number}"
  url = read_url(site_url, start, number)
  xml = fetch_with_curl(url)

  feed = XmlSimple.xml_in(xml)
  TumblrPost.make_files_for_posts_from_xml(feed)
  start += MAX_SUPPORTED_POSTS
end