class Petition < ActiveRecord::Base
  has_many :connected_petitions
end
