require 'sinatra'
require_relative 'environment.rb'

configure do
  set :static_root, '/public'
end

get '/' do
  petitions = Petition.all
  haml :index, locals: { petitions: petitions }
end
