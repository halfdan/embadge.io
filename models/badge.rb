class Badge < ActiveRecord::Base

  belongs_to :user
  has_many :badge_infos
end
