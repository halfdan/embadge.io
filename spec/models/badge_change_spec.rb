require 'spec_helper'

describe BadgeChange do
  let(:change) { Fabricate(:badge_change)}

  it "is valid" do
    expect(change.valid?).to be true
  end

  it "can be accepted" do
    change2 = Fabricate(:badge_change, badge: change.badge)

    expect(change.proposed?).to be true

    change.accept!

    # Applies version info
    expect(change.badge.version_start).to eq change.version_start
    expect(change.badge.version_end).to eq change.version_end
    expect(change.badge.version_range).to eq change.version_range

    # Sets status to accepted
    expect(change.accepted?).to be true
    # Rejects other proposed changes
    expect(change2.reload.rejected?).to be true
  end

  it "can be rejected" do
    change.reject!
    expect(change.rejected?).to be true
  end
end
