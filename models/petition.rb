class Petition < ActiveRecord::Base
  has_many :connected_petitions
  has_many :photos
  has_one :cover_photo, -> { where(cover: true) }, class_name: 'Photo'
end
