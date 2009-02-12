import codecs
import sys
import feedparser

#d = feedparser.parse(r'blog-02-12-2009.xml')


f = codecs.open("dat.txt", encoding='utf-8', mode='w')

d = feedparser.parse(sys.argv[1])
for i,j in enumerate(d.entries):
	if (d.entries[i].category == "http://schemas.google.com/blogger/2008/kind#post"):
		print(d.entries[i].title)
		print(d.entries[i].published)
		
		f.write(d.entries[i].title)
		f.write("\n")
		f.write(d.entries[i].published)
		f.write("\n")
		
		for j,k in enumerate(d.entries[i].content):
			print(d.entries[i].content[j]['value'])
			print("---")
			
			f.write(d.entries[i].content[j]['value'])
			f.write("\n")
			f.write("---")
			f.write("\n")
			
f.close()