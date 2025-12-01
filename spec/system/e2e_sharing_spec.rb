require "rails_helper"

RSpec.describe "End-to-end: Sharing todos", type: :system do
  it "lets owner share a todo and collaborator sees it" do
    owner_email = "owner_#{SecureRandom.hex(4)}@example.com"
    collaborator = User.create!(email: "collab_#{SecureRandom.hex(4)}@example.com", password: "password123", password_confirmation: "password123")

    # サインアップしてTodo作成
    visit new_user_path
    fill_in "Email", with: owner_email
    fill_in "Password", with: "password123"
    fill_in "Password confirmation", with: "password123"
    click_on "アカウント作成"

    visit new_todo_path
    fill_in "タイトル", with: "共有テストTodo"
    click_on "保存"

    expect(page).to have_text("共有テストTodo")

    # 共有追加
    fill_in "メールアドレスで共有", with: collaborator.email
    click_on "共有追加"
    expect(page).to have_text(collaborator.email)

    # ログアウトして共有ユーザーでログイン
    click_button "ログアウト"
    visit new_session_path
    fill_in "Email", with: collaborator.email
    fill_in "Password", with: "password123"
    within("form") { click_button "ログイン" }

    visit todos_path
    expect(page).to have_text("共有テストTodo")
  end
end
