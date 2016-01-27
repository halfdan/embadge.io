class BadgeChange < ActiveRecord::Base

  validates_presence_of :version_start, if: -> { self.version_range.blank? }
  validates_presence_of :version_range, if: -> { self.version_start.blank? }
  validates :badge, presence: true
  validates :user, presence: true

  has_many :votes
  belongs_to :badge
  belongs_to :user
end
