require_relative 'environment.rb'

configure do
  set :static_root, '/public'
end

get '/' do
  haml :index
end
