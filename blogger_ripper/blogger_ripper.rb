#!/usr/bin/env ruby -wKU -rubygems

class BlogPost
  attr_accessor :title, :date, :content
  
  def to_s
    "#{title}|#{date_only}|#{content}"
  end
  
  def date_only
    @date.split('T')[0]
  end
  
  def formatted_content
    r = content.gsub("<br />", "\n")
    r = r.gsub("<p>", "")    
    r = r.gsub("</p>", "")        
    r = r.gsub("&nbsp;", " ") 
    r = r.gsub("&amp;", "&")     
           
  end
  
  def create_file    
    filename = date_only + " " + title + ".html.txt"
    filename.gsub!('/', ' or ')

    File.open(filename, "w") do |file|
      file.puts title
      file.puts      
      file.puts formatted_content
    end        
  end  
end



# title
# date: 2005-10-16T17:13:00.000Z
# content lines
# --- record seperator  


RECORD_SEPARATOR = "---"

START = 0
GOT_TITLE = 1
GOT_DATE = 2

blog_post = nil
content = nil
state = START

while line=gets do
  line.chomp!
  
  case state
  when START
    blog_post = BlogPost.new
    blog_post.title = line
    content = []
    state = GOT_TITLE
  when GOT_TITLE
    blog_post.date = line
    state = GOT_DATE
  when GOT_DATE
    if line != RECORD_SEPARATOR
      content << line
    else
      blog_post.content = content.join("\n")
      blog_post.create_file
      state = START
    end    
  end
end



