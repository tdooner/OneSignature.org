require 'active_record'
require 'sinatra'

ENV['DATABASE_URL'] ||= 'sqlite3://./db/development.sqlite3'
ActiveRecord::Base.establish_connection

configure do
  set :static_root, '/public'
end

get '/' do
  haml :index
end
