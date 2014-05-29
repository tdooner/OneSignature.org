require 'sinatra'
require 'sinatra/multi_route'
require 'omniauth'
require 'omniauth/strategies/oauth2'
require_relative 'environment.rb'
require_relative 'whitehouse.rb'

module OmniAuth
  module Strategies
    class Causes < OmniAuth::Strategies::OAuth2
      include OmniAuth::Strategy

      option :fields, [:name, :email, :zip4]
      option :uid_field, :email
      option :client_options, {
        authorize_url: '/oauth_authorizations/new',
        token_url: '/oauth_authorizations/token',
        site: 'https://www.causes.com/',
        response_type: 'access_token',
      }

      def request_phase
        params = {:redirect_uri => callback_url}
        params.merge!(authorize_params)

        redirect client.auth_code.authorize_url(params)
      end
    end
  end
end

use Rack::Session::Cookie
use OmniAuth::Builder do
  provider :causes, ENV['CLIENT_ID'], ENV['CLIENT_SECRET']
end

configure do
  set :static_root, '/public'
  set :whitehouse_api_secret, ENV['WHITEHOUSE_API_SECRET']
end

enable :sessions

def whitehouse
  WhiteHouse.new(settings.whitehouse_api_secret, staging: true)
end

get '/' do
  petitions = Petition.all
  haml :index, locals: { petitions: petitions }
end

get '/petitions/:id' do
  petition = Petition.find(params[:id])
  haml :petition, locals: { petition: petition }
end

get '/new' do
  haml :new
end

post '/new' do
  params.symbolize_keys!

  p = Petition.create(params.slice(:creator_email, :title)) # TODO: remove title?
  ConnectedPetition::Causes.create(petition_id: p.id, url: params[:causes_url])
  ConnectedPetition::Change.create(petition_id: p.id, url: params[:change_url])
  ConnectedPetition::WeThePeople.create(petition_id: p.id, url: params[:whitehouse_url])

  redirect '/petitions/' + p.id.to_s
end

# Sign a petition action
route :get, :post, '/petitions/:id/sign' do
  # check for required petition signing information
  if session[:email].nil? || session[:email].blank? ||
     session[:first_name].nil? || session[:first_name].blank? ||
     session[:last_name].nil? || session[:last_name].blank?

    session[:return_path] = request.fullpath
    return redirect to("/get_info")
  end

  if whitehouse.sign(
    # TODO [nks]: replace hardcoded ID with a real petition ID
    petition_id: '533eefcbf51400142d000002',
    email:       session[:email],
    first_name:  session[:first_name],
    last_name:   session[:last_name],
  )
    "Whitehouse signature is GO"
  else
    "Whitehouse signing failed"
  end
end

# Display a form to get a user's petition signing information
get '/get_info' do
  haml :get_info
end

# Persist user information into their session
post '/get_info' do
  session[:email] = params[:info][:email]
  session[:first_name] = params[:info][:first_name]
  session[:last_name] = params[:info][:last_name]

  redirect to(session.delete(:return_path) || '/')
end
