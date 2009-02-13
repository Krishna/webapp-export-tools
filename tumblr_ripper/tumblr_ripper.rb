#!/usr/bin/env ruby -wKU -rubygems
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


class TumblrPost
  attr_reader :title, :content, :date
  
  def initialize(xmlHash)
    method_name = "make_from_" + xmlHash['type']
    send(method_name, xmlHash)
  end

  def to_s
    res = []
    res << @date
    res << @title
    res << @content
    res.join("\n")
  end
  
  def make_from_quote(xmlHash)
    source = (xmlHash['quote-source']) ? xmlHash['quote-source'][0] : ""
    
    @date = xmlHash['date-gmt']
    @title = "Quote"
    @content = xmlHash['quote-text'][0] + "\n\n" + source
  end
    
  def make_from_regular(xmlHash)
    @date = xmlHash['date-gmt']
    @title = xmlHash['regular-title'][0]
    @content = xmlHash['regular-body'][0] 
  end  
  
  def make_from_photo(xmlHash)
    @date = xmlHash['date-gmt']
    @title = "Photo"
    @content = xmlHash['photo-url'].collect {|h| "![](#{h['content']})" }.join("\n") 
    @content += "\n\n"
    @content += xmlHash['photo-caption'][0]
  end  
  
  def make_from_link(xmlHash)
    link_text = xmlHash['link-text'][0]
    link_url = xmlHash['link-url'][0]

    @date = xmlHash['date-gmt']
    @title = link_text
    @content = []
    @content << "[#{link_text}](#{link_url})"
    @content << xmlHash['link-description'][0] if xmlHash['link-description']
    @content = @content.join("\n\n")
  end 

  def make_from_conversation(xmlHash)
    @date = xmlHash['date-gmt']
    @title = xmlHash['conversation-title'][0]
    @content = xmlHash['conversation-text'][0]    
  end
  
  def make_from_video(xmlHash)
#   printf("%s|%s\n", xmlHash["type"], xmlHash.keys.sort.inspect)    
#   puts ">#{xmlHash.inspect}"
   
   @date = xmlHash['date-gmt']
   @title = "Video"
   @content = []
   @content << xmlHash['video-source'][0]
   @content << xmlHash['video-caption'][0]
   @content = @content.join("\n\n")
     
#   puts self
#   puts "----"  
  end
  
  def date_for_filename
    res = date.gsub(":", '')
    res = res.gsub(" GMT", '')
    res = res.gsub(" ", '_')    
    res = res.gsub("-", '')
    res
  end
  
  def filename
    res = "#{date_for_filename}_#{title}.md.txt"
    res.gsub!('/', ' or ')
    res.gsub!(':', ' -')    
    res
  end
  
  def create_file
    File.open(filename, "w") do |file|
      file.puts("##{title}")
      file.puts content
    end        
  end
  
end

if ARGV.size != 1
  STDERR.puts usage
  exit
end

filename = ARGV[0]
feed = XmlSimple.xml_in(filename)

posts = feed["posts"][0]["post"]
posts.each do |p|
  t = TumblrPost.new(p)
  t.create_file
end
