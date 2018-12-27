require 'sqlite3'

db=SQLite3::Database.new 'BarberShop.sqlite'

db.execute "insert into Cars (Name, Price) values ('Запор', 50)"

db.close