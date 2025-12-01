require "rails_helper"

RSpec.describe "User signup and login", type: :system do
  let!(:user) { User.create!(email: "login@example.com", password: "password123", password_confirmation: "password123") }

  it "signs up a user named example_user and shows logged-in state" do
    visit new_user_path

    fill_in "Email", with: "example_user@example.com"
    fill_in "Password", with: "password123"
    fill_in "Password confirmation", with: "password123"
    click_on "アカウント作成"

    expect(page).to have_text("アカウントを作成しました").or have_text("ログイン中: example_user@example.com")
    expect(page).to have_button("ログアウト")
  end

  it "logs in an existing user" do
    visit new_session_path

    fill_in "Email", with: user.email
    fill_in "Password", with: "password123"
    within("form") { click_button "ログイン" }

    expect(page).to have_button("ログアウト")
    expect(page).to have_text("ログインしました").or have_text("ログイン中: #{user.email}")
  end
end
