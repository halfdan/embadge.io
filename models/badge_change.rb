class BadgeChange < ActiveRecord::Base
  has_many :votes
  belongs_to :badge
  belongs_to :user

  validates :version_start, presence: true, if: -> { self.version_range.blank? }
  validates :version_range, presence: true, if: -> { self.version_start.blank? }
  validates :badge, presence: true
  validates :user, presence: true

  VALID_STATUSES = %w(proposed rejected accepted)
  validates :status, inclusion: { in: VALID_STATUSES,
    message: "%{value} is not a valid status" }

  VALID_STATUSES.each do |status_name|
    scope status_name, -> { where(status: status_name) }

    define_method("#{status_name}?") do
      status == status_name
    end
  end

  # Sets status to accepted.
  # Rejects all other changes.
  # Copies attributes over to badge
  def accept!
    badge.apply! self
    self.status = :accepted
    self.save
  end

  def reject!
    self.status = :rejected
    self.save!
  end
end
