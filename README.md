#### Sinatra 정리

- 필수 gem 설치

  `$ gem install sinatra`

  `$ gem install sinatra-reloader`

  

- 시작 페이지 만들기 (routing 설정 및 대응되는 view 설정)

  ~~~ruby
  #app.rb
  
  require 'sinatra'
  require 'sinatra/reloader'
  
  get '/' do #routing 
      send_file 'index.html'  #index.html파일을 보내줘
  end
  
  get 'lunch' do   # 'lunch 경로로 들어왔을 때'
      erb :lunch #views 폴더 안에 있는 lunch.erb를 보여줘
  end
  
  ~~~



- 폴더 구조

  - app.rb
  - views 
    - .erb
    - layout.erb
  - Index.html

- layout.erb

  ~~~html
  <html> 
      <head>
          <title>게시판</title>
      </head>
      <body>
       <%= yield %>
       </body>
  </html>
  ~~~

  ~~~ruby
  def hello 
      puts "hello"
      yield
      puts "bye"
  end
  
  # => {} : block / 코드 덩어리
  hello{puts "dahye"}
  # => hello dahye bye
  ~~~

  

- erb에서 루비 코드 활용하기

  ~~~ruby
  #app.rb
  
  get 'lunch' do
      @lunch = [""]
      erb :lunch
  end
  ~~~

  ~~~ruby
  <!-- lunch.erb -->
     
  <%= @lunch %>
  ~~~



- params (받아오는 방법)

  - variable routing

    ~~~ruby
    #app.rb
    
    get '/hello/:name'
     @name = params[:name]
     erb :name
    end
    ~~~

  - form tag를 통해서 받는 법

    ~~~html
    <form action = "/posts/create">
        <input type = "text" name = "title">
        <input type = "submit">
    </form>
    ~~~

    ~~~ruby
    #app.rb
    #params
    #{title: "asdf"}
    get '/posts/create' do
        @title = params[:title]
    end
    ~~~




- ORM : Object relation mapper

  - 객체지향언어(ruby)와 데이터베이스(sqlite)를 연결하는 것을 도와주는 도구
  - [Datamapper] ('http://recipes.sinatrarb.com/p/models/data_mapper')

  

- 사전준비사항

  `gem install datamapper`

  `gem install dm-sqlite-adapter`

  ~~~ruby
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
  
  # Post 테이블 생성 (Relational)
  Post.auto_upgrade!
  ~~~

  

- 데이터 조작

  - 기본

    `Post.all` 

    

  - C (create)

    ~~~ruby
    #첫번째 방법
    Post.create(title: "test", body: "test")
    #두번째 방법
    p = Post.new
    p.title = "test"
    p.body = "test"
    p.save #db에 작성
    ~~~

  - R (read)

    ~~~~ruby
    Post.get(1) #get(id)
    ~~~~

  - U (update)

    ~~~ruby
    #첫번째 
    Post.get(1).update(title : "test", body: "test")
    #두번째
    p = Post.get(1)
    p.title = "제목"
    p.body = "내용"
    p.save
    ~~~

  - D (destroy)

    ~~~ruby
    Post.get(1).destroy
    ~~~

  

- CRUD 만들기

  ~~~ruby
  #사용자에게 입력받는 창
  get '/posts/new' do
  end
  
  #실제 db에 저장하는 곳
  get '/posts/create' do
      Post.create(title: params[:title], body: params[:body])
  end
  ~~~

  

- Read : variable routing

  ~~~ruby
  #app.rb
  get 'posts/:id' do
      @post = Post.get(params[:id])
  end
  ~~~




- bunlder를 통한 gem 관리

  - 어플리케이션의 의존성(dependancy)를 관리 해주는 bundler

    1. bundler 설치

       `gem install bundler`

    2. Gemfile 작성 : 루트 디렉토리에 만들기

       ~~~
       source 'https://rubygems.org'
       gem 'sinatra'
       gem 'sinatra-reloader'
       gem 'datamapper'
       gem 'dm-sqlite-adapter'
       ~~~

    3. gem설치

       `bundle install`



- Heroku 배포

  1. heroku에서 addon추가

     `heroku postgre`

     

  2. `Gemfile` 수정

     ~~~
     source 'https://rubygems.org
     gem 'sinatra'
     gem 'sinatra-reloader'
     gem 'datamapper'
     gem 'bcrypt'
     gem 'json', '~>1.6'
     gem 'rack'
     
     group :production do
       gem 'pg'
       gem 'dm-postgre-adapter'
     end
     
     group :development, :test do
       gem 'dm-sqlite-adapter'
     end
     ~~~

     - pg를 쓰는 이유는 heroku에서 지원하는 db이기 때문

     - `bundle install --without production`

       

  3. `model.rb` 파일에서  db경로 수정

     ~~~ruby
     #개발환경에서는 sqlite 사용
     configure :development do
          DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/blog.db")
     end
     
     #production환경에서는 
     configure :production do
         DataMapper::setup(:default, ENV["DATABASE_URL"])
     end
     ~~~

     - ENV["DATABASE_URL"] 은 heroku 서버에서 설정되어있는 환경변수

       

  4. `config.ru` 추가 -> 루트 디렉토리에

     ~~~ruby
     require './app'
     run Sinatra::Application
     ~~~

     - 헤로쿠에서 서버를 실행하는 방법이 rake이기 때문에

     - c9에서는 `$ ruby app.rb -o $IP` 로 실행

     - 헤로쿠에서는 `$ bundle exec rakeup config.ru -o $IP -p $PORT` 로 실행 

       

  5. console에서 heroku로 push 하는 방법

     `$ heroku login`

     `$ git add .`

     `$ git commit -m "msg"`

     `$ git push heroku master`

