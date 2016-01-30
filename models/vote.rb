class Vote < ActiveRecord::Base
  belongs_to :user
  belongs_to :badge_change

  after_create do
    if self.badge_change.votes.count > 2
      badge_change.accept!
    end
  end
end
