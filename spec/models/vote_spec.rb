require 'spec_helper'

describe Vote do
  let(:vote) { Fabricate(:vote)}

  it "is valid" do
    expect(vote.valid?).to be true
  end

  it "auto accepts when threshold is reached" do
    expect(vote.badge_change.accepted?).to be false

    vote2 = Fabricate(:vote, badge_change: vote.badge_change)
    expect(vote.badge_change.reload.accepted?).to be false

    vote3 = Fabricate(:vote, badge_change: vote.badge_change)
    expect(vote.badge_change.reload.accepted?).to be true
  end
end
