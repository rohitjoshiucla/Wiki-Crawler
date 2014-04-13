require 'open-uri'
require 'nokogiri'
require 'oauth'
require 'sqlite3'
require 'date'
require 'data_mapper'
require 'json'
require 'i18n'
class CrawlerController < ApplicationController
  #Action to create DataMapper instance i.e Table in Database
  #
  #@param []
  #
  #return [String]
  def _GetWikiData
    begin
      page=Nokogiri::HTML(open('http://en.wikipedia.org/wiki/List_of_American_film_actresses'))
      anchor=page.css('div[class="div-col columns column-width"] ul li a')
      DataMapper.finalize
      DataMapper.auto_migrate!
      DataMapper.auto_upgrade!
      anchor.each{|element|
        actress=Dmapper.new(:name=> I18n.transliterate(element['title'].sub('(actress)',"")).gsub(/[^0-9a-z ]/i, ''),:url=>"")
        actress.save
      }
      @response="success"
    rescue Exception =>e
      @response=e.to_s
    end
  end

  #Action to update DataMapper instance i.e Table in Database
  #
  #@param []
  #
  #return [String]
  def _GetTwitterData
    consumer = OAuth::Consumer.new("InspcUqL1BllUxvd78Y0Q", "NwNWjKA1RDNcNKKcwC0UtaRNcC9Edy1zOgxFmhwzd8",{
         :site => "http://api.twitter.com",
         :scheme => :header
      }
    )
    token_hash = { :oauth_token => "1368765691-5psuTFZTZ4WhzOD3y46kTLwJpLqtc6ToU5oYco9",
                   :oauth_token_secret => "NdNubll9qQzIMZBeBGfRM2wMnxZjr1ThcqFKhzaXiAmHj"
    }
    access_token= OAuth::AccessToken.from_hash(consumer,token_hash)
    @response=Ratelimit.rate_limit(consumer,access_token)
  end
end
