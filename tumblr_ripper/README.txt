This directory contains two scripts pull down the content of a tumblr site:

- tumblr_slurp.rb
- tumblr_ripper.rb

## tumblr_slurp.rb

This is the simplest script to use. It pulls down the xml feed for the tumblr posts using curl, and then creates one file per post. Note: private posts are not pulled down.

	Usage: tumblr_slurp.rb <tumblr website url> <starting post number> <number of posts to pull down>
	

## tumblr_ripper.rb

This script does not pull down the xml export data file from tumblr itself. You use it to parse the export xml format that tumblr exposes, which you must download yourself. A new file is then created for each blog post contained in the xml file.

###Using it

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
- Remove the dependency on curl in tumblr_slurp.rb
- Remove the need to specify the start and number of posts to pull down in tumblr_slurp.rb. Just pull down all available posts.

KK