require 'sinatra'
require 'omniauth'
require 'omniauth/strategies/oauth2'
require_relative 'environment.rb'

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
end

get '/' do
  petitions = Petition.all
  haml :index, locals: { petitions: petitions }
end
