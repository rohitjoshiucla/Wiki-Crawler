class Database < ActiveRecord::Base

  #Method to execute query
  #
  #@param [Sqlite Query]
  #
  #return [ResultSet]
  def self.execute(query)
    begin
      db=SQLite3::Database.open "db/development.sqlite3"
      return db.execute query
    rescue SQLite3::Exception => e
      return e
    ensure
      db.close
    end
  end

end
