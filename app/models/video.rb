class Video < ActiveRecord::Base
  attr_accessible :youtube_id
  has_many :comments
end
