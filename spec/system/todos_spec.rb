require "rails_helper"

RSpec.describe "Todos", type: :system do
  let!(:user) { create(:user, email: "user@example.com", password: "password", password_confirmation: "password") }

  before do
    visit new_session_path
    fill_in "Email", with: "user@example.com"
    fill_in "Password", with: "password"
    within("form") { click_button "ログイン" }

    # ログイン完了を確認し、一覧へ移動
    expect(page).to have_text("ログインしました").or have_link("新規作成")
    visit todos_path
    expect(page).to have_link("新規作成")
  end

  it "creates a todo successfully" do
    visit root_path

    click_on "新規作成"
    fill_in "Title", with: "Write system spec"
    fill_in "Description", with: "Use rack_test driver"
    fill_in "締切日", with: (Date.today + 1).to_s
    select "Medium", from: "優先度"
    click_on "保存"

    expect(page).to have_text("Todo was successfully created")
    expect(page).to have_text("Write system spec")
  end
end
