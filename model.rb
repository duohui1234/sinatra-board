require 'data_mapper' # metagem, requires common plugins too.


#dataMapper 로그찍기
DataMapper::Logger.new($stdout, :debug)

#개발환경에서는 sqlite 사용
configure :development do
     DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/blog.db")
end

#production환경에서는 
configure :production do
    DataMapper::setup(:default, ENV["DATABASE_URL"])
end


class Post
  include DataMapper::Resource
  property :id, Serial
  property :title, String
  property :body, Text
  property :created_at, DateTime
end

class User
  include DataMapper::Resource
  property :id, Serial
  property :username, String
  property :email, String
  property :password, Text
  property :created_at, DateTime
end


# Perform basic sanity checks and initialize all relationships
# Call this when you've defined all your models
DataMapper.finalize

# automatically create the post table
Post.auto_upgrade!
User.auto_upgrade!

