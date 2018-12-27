require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

def is_barber_exists? db, name
  db.execute('select * from Barbers where name=?', [name]).length > 0
end

def seed_db db, barbers
  barbers.each do |barber|
      if !is_barber_exists? db, barber #если не найден добавить
          db.execute 'insert into Barbers (name) values (?)', [barber]
      end
  end
end

def get_db
  db = SQLite3::Database.new 'barbershop.db' 
  db.results_as_hash=true
  return db
end

before do
  db = get_db
  @barbers = db.execute 'select * from Barbers' 
end

configure do 
  db = get_db 
  db.execute 'create table if not exists
              "Users" 
              (
                     "id" integer primary key autoincrement,
                     "username" text,
                     "phone" text,
                     "datestamp" text,
                     "barber" text,
                     "color" text
              )'

  db.execute 'create table if not exists
              "Barbers" 
              (
                     "id" integer primary key autoincrement,
                     "name" text
              )'

  seed_db db, ['dfghfdgh', 'dfghfghfg', 'tyyhdfgh', 'ythfghdfgh', 'rkljfgnfk']
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
  
  erb "OK"
end

get '/showusers' do
    db = get_db
    @results = db.execute 'select * from Users order by id desc'
    erb :showusers
end










