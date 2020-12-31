require 'sqlite3'
require_relative '../lib/student'

# DB is equal to a hash that contains our connection to the database
DB = {:conn => SQLite3::Database.new("db/students.db")}