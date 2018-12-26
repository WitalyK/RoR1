require 'SQLite3'

db=SQLite3::Database.new 'mydatabase.sqlite'

db.execute "insert into Cars (Name, Price) values ('Запор', 50)"

db.close