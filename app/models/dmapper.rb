require 'data_mapper'
require 'dm-sqlite-adapter'

DataMapper::setup(:default,"sqlite3://"+Dir.pwd.to_s()+"/db/development.sqlite3")
class Dmapper
  include DataMapper::Resource
  property :id, Serial
  property :name, String
  property :url, String
  property :created_at, DateTime
  property :updated_at, DateTime
end

DataMapper.finalize
DataMapper.auto_upgrade!