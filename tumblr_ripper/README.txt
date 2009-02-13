This directory contains a script to parse the export xml format that tumblr exposes. A new file is then created for each blog post contained in the xml file.

##Using it

The first thing you need to do is grab the xml that the tumblr API helpfully exposes. I used curl to do this, like so:

	curl "http://mysite.tumblr.com/api/read?filter=none&start=0num=50" > data00.xml
	curl "http://mysite.tumblr.com/api/read?filter=none&start=51num=50" > data01.xml	

The tumblr API only lets you download 50 entries at a time, so you may need to invoke it a few times.
See the [tumblr API documentation](http://www.tumblr.com/docs/api) for all the details.

Ok so now you have one or more exported xml files containing the contents of your tumblr blog. You just need to run the Ruby script against each of the xml files:

	ruby tumblr_ripper.rb data00.xml
	ruby tumblr_ripper.rb data01.xml	
	
The script will create one file per blog entry, in the current directory.


##Enhancements 

- Add support for the tumblr post type of 'audio'
- The script should really fetch the data from tumblr by itself (ie remove the need for curl or similar tool)

KK