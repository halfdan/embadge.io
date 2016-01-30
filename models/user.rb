class User < ActiveRecord::Base

  has_many :badges
  has_many :votes

  def self.create_with_omniauth(auth)
    create! do |user|
      user.provider = auth['provider']
      user.uid = auth['uid']

      if auth['info']
         user.name = auth['info']['name'] || ""
         user.handle = auth['info']['nickname'] || ""
         user.email = auth['info']['email'] || ""
      end
    end
  end

  def can_vote_for?(change)
    change.votes.where(user: self).count == 0
  end

  def vote_for(change)
    if can_vote_for? change
      Vote.create user: self, badge_change: change
    end
  end
end
