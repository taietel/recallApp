#notes model (table)
configure do
  DataMapper.setup(:default, {
    :adapter   => "sqlite",
    :database  => "#{Dir.pwd}/database.db"
  })
end

class Note
  include DataMapper::Resource
  property :id, Serial
  property :content, Text, :required => true
  property :complete, Boolean, :required => true, :default => false
  property :created_at, DateTime
  property :updated_at, DateTime
end

DataMapper.finalize.auto_upgrade!