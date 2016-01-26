class BadgeInfo < ActiveRecord::Base

  validates_presence_of :version_start, if: -> { self.version_range.blank? }
  validates_presence_of :version_range, if: -> { self.version_start.blank? }

  has_many :votes
  belongs_to :badge
  belongs_to :user, foreign_key: :created_by

  scope :current, -> { where(is_current: true) }

  def current!
    # Start transaction to set this as current and unset
  end
end
