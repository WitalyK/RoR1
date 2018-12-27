require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

def get_db
  return SQLite3::Database.new 'barbershop.db'
end

configure do 
  db = get_db 
  db.execute 'create table if not exist
              "Users" 
              (
                     "id" integer primary key autoincrement,
                     "username" text,
                     "phone" text,
                     "datestamp" text,
                     "barber" text,
                     "color" text
              )'
end

get '/' do

  erb 'Hello!'
end 

get '/about' do
	erb :about
end

get '/visit' do
	erb :visit
end


post '/visit' do
  @username = params[:username]
  @phone = params[:phone]
  @datetime = params[:datetime]
  @barber = params[:barber]
  @color = params[:color]
  
  hh = {  :username => 'Enter NAme',
          :phone => 'Enter phone',
          :datetime => 'Enter date and time'  }
          
  @error = hh.select {|key,_| params[key] == ""}.values.join(", ")

  if @error != ''
    return erb :visit
  end
  
  db = get_db
  db.execute 'insert into users (username, phone, datestamp, barber, color)
                          values ( ?, ?, ?, ?, ? )',
               [@username, @phone, @datetime, @barber, @color]
  
  erb "OK, username is #{@username}, #{@phone}, #{@datetime}"
end

get '/showusers' do
    db = get_db
    @results = db.execute 'select * from Users order by id desc'
    erb :showusers
end










