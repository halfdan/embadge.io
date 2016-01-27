class Vote < ActiveRecord::Base
  belongs_to :user
  belongs_to :badge_change
end
