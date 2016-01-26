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
end
