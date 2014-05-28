require 'active_record'
require 'sinatra'

ENV['DATABASE_URL'] ||= 'sqlite3://./db/development.sqlite3'
ActiveRecord::Base.establish_connection

get '/' do
  haml :index
end
