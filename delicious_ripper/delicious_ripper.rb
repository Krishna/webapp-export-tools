#!/usr/bin/env ruby -wKU -rubygems
require 'rexml/document'
require 'time'
require 'fastercsv'

def usage
  <<-EOU
Usage: #{$0} <delicious xml export filename>

Script to create a single CSV file containing all your bookmarks.

1. Export the content of your delicious bookmarks to xml format (go here: https://api.del.icio.us/v1/posts/all)
2. Run this script against the downloaded file.

The script then writes to standard output, the boomkarks data in this CSV format:

  url, title, description, date the bookmark was made (YYYYMMDD), public/private, [comma separated tags]

EOU
end

class Bookmark
  attr_reader :title, :description, :link, :tags, :time, :shared

  def initialize(title, description, link, tags, time, shared)
    @title, @description, @link = title, description, link
    @time = Time.iso8601(time)
    @tags = tags.split(' ').sort
    @shared = shared || "yes"
  end

  def time_as_yyyymmdd
    @time.strftime("%Y%m%d")
  end
  
  def public_or_private
    return "private" if @shared == "no"
    "public"
  end

  def to_s
    to_csv
  end
  
  def to_csv
    FasterCSV.generate do |csv|
      csv << [@link, @title, @description, time_as_yyyymmdd, public_or_private, *@tags]
    end    
  end

end


def load_bookmarks(filename)
  bookmarks = []
  doc = nil
  
  File.open(filename) do |fp|
    doc = REXML::Document.new fp
  end
  
  doc.elements.each('/posts/post') do |post|
    attr = post.attributes

    bookmark = Bookmark.new(attr['description'], attr['extended'], 
                            attr['href'], attr['tag'], attr['time'], attr['shared'])
    
    bookmarks << bookmark
  end
  bookmarks
end


if ARGV.size != 1
  STDERR.puts usage
  exit
end

filename = ARGV[0]
bookmarks = load_bookmarks(filename)
bookmarks.each do |bookmark|
    puts bookmark
end