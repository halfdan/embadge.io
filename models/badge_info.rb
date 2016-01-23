class BadgeInfo < ActiveRecord::Base

  has_many :votes
  belongs_to :badge
end
