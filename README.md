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




