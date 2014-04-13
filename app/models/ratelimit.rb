require 'i18n'
class Ratelimit

  #Method to fire rate limited requests
  #
  #@param [consumer,access token]
  #
  #return [String]
  def self.rate_limit(consumer,access_token)
    num_attempts = 0
    result = Database.execute("SELECT name FROM dmappers WHERE url='' LIMIT 180")
    file=File.open(Dir.pwd.to_s()+"/log.txt",'a')

    if(result.size()==0)
      return 'done'
      else if(result.size()<180)
        max_attempts = result.size()
      else
        max_attempts = 180
      end
    end

    result.each{|actress|
      num_attempts +=1
      query= I18n.transliterate(actress[0]).gsub(/[^0-9a-z ]/i, '').gsub(" ","%20")
      name=actress[0]



      if num_attempts<=max_attempts
        @response = consumer.request(:get,"https://api.twitter.com/1.1/users/search.json?q="+query+"&page=1&count=1",access_token).body

        puts num_attempts
        puts @response

        #check for empty @response

        if(@response.to_s()=="[]")
          file.write(actress[0].to_s()+" invalid \n")
          Database.execute("UPDATE dmappers SET url = 'invalid' WHERE name ='"+name+"' " )
        else
          parsed=JSON.parse(@response.to_s)

          #check for error @response
          if(parsed.kind_of?(Array)==true)
            #check for other response
            verified=parsed[0]["verified"]
            screen_name = parsed[0]["screen_name"]

            if(verified.equal?true)
              file.write(actress[0].to_s()+" http://twitter.com/"+screen_name.to_s()+"\n")
              Database.execute("UPDATE dmappers SET url = 'https://twitter.com/" + screen_name.to_s() +"' WHERE name ='"+name+"' " )
            else
              file.write(actress[0].to_s()+" invalid \n")
              Database.execute("UPDATE dmappers SET url = 'invalid' WHERE name ='"+name+"' " )
            end

          else
            file.close
            puts "error"
            sleep(60)
            return Ratelimit.rate_limit(consumer,access_token)
          end

        end

      else
        file.close
        puts "exceeded"
        sleep(60)
        return Ratelimit.rate_limit(consumer,access_token)
      end

    }
    file.close
    puts "retry"
    return Ratelimit.rate_limit(consumer,access_token)

  end

end
