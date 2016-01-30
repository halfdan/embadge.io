require 'spec_helper'

describe User do
  let(:user) { Fabricate(:user)}

  it "is valid" do
    expect(user.valid?).to be true
  end

  it "can vote for badge only once" do
    change = Fabricate(:badge_change)

    expect(user.can_vote_for?(change)).to be true

    vote = Fabricate(:vote, user: user, badge_change: change)

    expect(user.can_vote_for?(change)).to be false
  end
end
