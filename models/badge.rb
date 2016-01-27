class Badge < ActiveRecord::Base

  belongs_to :user
  has_many :badge_changes

  # We want a title and url if the badge is to be publicly listed.
  validates :url, presence: true
  validates :title, presence: true
  validates :label, presence: true
  validates :user, presence: true
  validates_presence_of :version_start, if: -> { self.version_range.blank? }
  validates_presence_of :version_range, if: -> { self.version_start.blank? }

  def definition
    {
      start: version_start,
      end: version_end,
      range: version_range,
      label: label,
      id: id
    }
  end

  def apply! change
    self.version_start = change.version_start
    self.version_end = change.version_end
    self.version_range = change.version_range
    self.save!
  end
end
