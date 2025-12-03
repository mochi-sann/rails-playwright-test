require 'rails_helper'

RSpec.describe User, type: :model do
  it "requires email uniqueness" do
    create(:user, email: "dupe@example.com")

    user = build(:user, email: "dupe@example.com")

    expect(user).not_to be_valid
    expect(user.errors[:email]).to include("has already been taken")
  end

  it "requires password" do
    user = User.new(email: "test@example.com")

    expect(user).not_to be_valid
    expect(user.errors[:password]).to be_present
  end
end
