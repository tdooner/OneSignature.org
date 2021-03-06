require 'active_record'

ENV['DATABASE_URL'] ||= 'sqlite3:db/development.sqlite3'
ActiveRecord::Base.establish_connection

$LOAD_PATH << '.'
Dir['models/*.rb'].each { |f| require f }
