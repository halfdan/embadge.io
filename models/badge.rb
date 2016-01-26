class Badge < ActiveRecord::Base

  belongs_to :user
  has_many :badge_infos

  # We want a title and url if the badge is to be publicly listed.
  validates_presence_of :url
  validates_presence_of :title

  accepts_nested_attributes_for :badge_infos

  def definition
    current = badge_infos.current.first
    {
      start: current.version_start.blank? ? nil : current.version_start,
      end: current.version_end.blank? ? nil : current.version_end,
      range: current.version_range.blank? ? nil : current.version_range
    }
  end
end
