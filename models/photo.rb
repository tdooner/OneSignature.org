class Photo < ActiveRecord::Base
  belongs_to :petition

  before_save :set_as_cover_photo, if: -> { petition.photos.blank? }

  def set_as_cover_photo
    self.cover = true
  end
end
