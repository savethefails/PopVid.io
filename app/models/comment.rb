class Comment < ActiveRecord::Base
  attr_accessible :duration, :text, :timestamp, :video_id
end
