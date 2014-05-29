require 'pry'

# Helper for WhiteHouse We The People API
class WhiteHouse
  API_ROOT = 'https://api.whitehouse.gov/'
  STAGING_API_ROOT = 'https://11111011100.api.whitehouse.gov'

  attr_reader :staging

  def initialize(api_key, staging: false)
    @api_key = api_key
    @staging = staging
  end

  # Sign a petition
  # @param [Hash] options
  # @option options [String] :petition_id The petition to sign
  # @option options [String] :email The signers email address
  # @option options [String] :first_name The signers first name
  # @option options [String] :last_name The signers last name
  def sign(options)
    url = "/v1/signatures?api_key=#{api_key}"
    response = connection.post(url, options.to_json) do |request|
      request.headers['Content-Type'] = 'application/json'
    end
    yield response if block_given?
    response.status == 200
  end

private
  attr_reader :api_key

  def connection
    domain = API_ROOT
    options = {}

    if staging
      domain = STAGING_API_ROOT
      options[:ssl] = { verify: false } # staging uses an invalid certificate
    end

    Faraday.new(domain, options)
  end
end
