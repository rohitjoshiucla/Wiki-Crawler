WebCrawler version 1.0 12/15/2013

General Usage
-------------
Look for twitter accounts for listed celebrities on wikipedia

Installation Requirements
-------------------------
Ruby on Rails
http://www.rubylang.org/en/
http://rubygems.org/

Running Instructions
--------------------
The database of celebrities can be created by running 
http://hostname:port/Crawler/_GetWikiData
e.g. http://localhost:3000/Crawler/_GetWikiData
Here the "name" is parsed from Wikipedia and "url" is empty

The database can be updated for url by running
http://hostname:port/Crawler/_GetTwitterData
e.g. http://localhost:3000/Crawler/_GetTwitterData
Here the "url" is retrieved from Twitter acoounts of users

TODO
----
Enable modules
Enable unit tests


