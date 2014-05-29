require 'open-uri'
require 'nokogiri'

class ConnectedPetition < ActiveRecord::Base
  before_save :get_info!, on: :create

  def get_info!
    raise NotImplementedError
  end
end

class ConnectedPetition::Causes < ConnectedPetition
  def get_info!
    self.url = URI(url).tap { |u| u.query = nil }.to_s

    doc = Nokogiri::HTML(open(url))

    self.title = doc.css('.campaign-title a').text
    self.target = doc.css('.action-target').text
    self.description =
      doc.css('.actions-how-help .long .user_content').text.presence ||
      doc.css('.actions-how-help .user_content').text
  end
end

class ConnectedPetition::Change < ConnectedPetition
  def get_info!
    api_uri = URI('https://api.change.org/v1/petitions/get_id')
    api_uri.query = URI.encode_www_form(api_key: ENV['CHANGE_API_KEY'],
                                        petition_url: url)

    petition_id = JSON.parse(open(api_uri).read)["petition_id"].to_s
    api_uri = URI('https://api.change.org/v1/petitions/' + petition_id)
    api_uri.query = URI.encode_www_form(api_key: ENV['CHANGE_API_KEY'])

    petition = JSON.parse(open(api_uri).read)
    self.title = petition["title"]
    self.target = petition["targets"].first["name"]
    self.description = Nokogiri::HTML.parse(petition["overview"]).text
  end
end

class ConnectedPetition::WeThePeople < ConnectedPetition
  # TODO: Complete this when the WH.gov API comes back online.
  def get_info!
    url = 'https://petitions.whitehouse.gov/petition/end-current-policy-censoring-free-speech-discussing-radical-islam/wJwGTVsc'

    api_uri = URI('http://11111011100.api.whitehouse.gov/v1/petitions.json')
    api_uri.query = URI.encode_www_form(url: url)

    JSON.parse(open(api_uri).read)
  end
end
