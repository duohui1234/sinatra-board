gem 'json', '~>1.6'
require 'sinatra'
require 'sinatra/reloader'
require './model.rb'


before do 
    p '********************'
    p params
    p '********************'
end
  
get '/' do
 send_file 'index.html'
end


get '/lunch' do
   @lunch = ["맥도날드","순남시래기","20층","김밥카페"].sample
   erb :lunch
end


#게시글을 모두 보여주는 곳
get '/posts' do
    @posts = Post.all.reverse
    # @posts = Post.all(order=> [:id.desc])
    erb :'posts/posts'
end

#게시들을 쓸 수 있는 곳
get '/posts/new' do
    erb :'posts/new'
end


get '/posts/create' do
    @title = params[:title] 
    @body = params[:body]
    Post.create(title: @title, body: @body)
    erb :'posts/create'
end


#CRUD - Read
get '/posts/:id' do
    #id를 받아와서
    @id = params[:id]
    
    #db에서 찾는다
    @post = Post.get(@id)
    erb :'posts/show'
end


get '/posts/destroy/:id' do
   @id = params[:id]
   Post.get(@id).destroy
   erb :'/posts/destroy'
end



get '/posts/edit/:id' do
     @id = params[:id]
     @post = Post.get(@id)
     erb :'posts/edit'
end

get '/posts/update/:id' do
    @id = params[:id]
    Post.get(@id).update(title: params[:title], body: params[:body])
    # @post = Post.get(@id)  
    # erb :'/posts/update'
    redirect '/posts/'+@id
end