Sinatra 정리

- 필수 gem 설치
  $ gem install sinatra
  $ gem install sinatra-reloader
  
- 시작 페이지 만들기
      #app.rb
      
      require 'sinatra'
      require 'sinatra/reloader'
      
      get '/' do #routing 
          send_file 'index.html'  #index.html파일을 보내줘
      end
      
      get 'lunch' do   # 'lunch 경로로 들어왔을 때'
          erb :lunch #views 폴더 안에 있는 lunch.erb를 보여줘
      end
      



- 폴더 구조
  - app.rb
  - views / lunch.erb
  - Index.html
    
- erb에서 루비 코드 활용하기
      #app.rb
      
      get 'lunch' do
          @lunch = [""]
          erb :lunch
      end
      <!-- lunch.erb -->
         
      <%= @lunch %>
  
- ORM : Object relation mapper
  - 객체지향언어(ruby)와 데이터베이스(sqlite)를 연결하는 것을 도와주는 도구
  - [Datamapper] ('http://recipes.sinatrarb.com/p/models/data_mapper')
  
- 사전준비사항
  gem install datamapper
  gem install dm-sqlite-adapter
      #app.rb
      #c9에서 json 라이브러리 충돌로 인한 코드
      gem 'json', '~>1.6'
      require 'data_mapper' # metagem, requires common plugins too.
      
      # blog.db 세팅
      DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/blog.db")
      
      #Post 객체 생성
      class Post
        include DataMapper::Resource
        property :id, Serial
        property :title, String
        property :body, Text
        property :created_at, DateTime
      end
      
      # Perform basic sanity checks and initialize all relationships
      # Call this when you've defined all your models
      DataMapper.finalize
      
      # automatically create the post table
      Post.auto_upgrade!
  
- 데이터 조작
  - 기본
    Post.all 
    
  - C (create)
        #첫번째 방법
        Post.create(title: "test", body: "test")
        #두번째 방법
        p = Post.new
        p.title = "test"
        p.body = "test"
        p.save #db에 작성
    
  - R (read)
        Post.get(1) #get(id)
    
  - U (update)
        #첫번째 
        Post.get(1).update(title : "test", body: "test")
        #두번째
        p = Post.get(1)
        p.title = "제목"
        p.body = "내용"
        p.save
    
    
  - D (destroy)
        Post.get(1).destroy
  
