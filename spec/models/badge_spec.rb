require 'spec_helper'

describe Badge do
  let(:badge) { Fabricate(:badge)}

  it "is valid" do
    expect(badge.valid?).to be true
  end

  it "can apply a change" do
    change = Fabricate(:badge_change, badge: badge, version_start: nil, version_range: "^2.0.0")

    badge.apply! change
    expect(badge.version_start).to eq change.version_start
    expect(badge.version_end).to eq change.version_end
    expect(badge.version_range).to eq change.version_range
  end
end
