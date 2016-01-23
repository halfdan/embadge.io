class User < ActiveRecord::Base

  has_many :badges
  has_many :votes
end
