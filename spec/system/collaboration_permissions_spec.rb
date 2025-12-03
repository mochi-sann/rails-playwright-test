require "rails_helper"

RSpec.describe "Todo collaboration permissions", type: :system, capybara_driver: :playwright do
  before do
    unless ENV["CAPYBARA_ALLOW_SERVER"] == "1" || ENV["CAPYBARA_DRIVER"].present?
      skip "Playwright system specs require a real browser driver (set CAPYBARA_ALLOW_SERVER=1)"
    end
  end
  def login_as(user, password: "password")
    visit new_session_path
    fill_in "Email", with: user.email
    fill_in "Password", with: password
    within("form") { click_button "ログイン" }
    expect(page).to have_button("ログアウト")
  end

  def logout
    click_button "ログアウト"
  end

  it "allows editor collaborators to find shared todos and comment" do
    owner = create(:user, password: "password", password_confirmation: "password")
    collaborator = create(:user, password: "password", password_confirmation: "password")

    login_as(owner)

    visit new_todo_path
    fill_in "Title", with: "Shared Playwright Todo"
    fill_in "Description", with: "End-to-end permissions coverage"
    fill_in "締切日", with: (Date.today + 2).to_s
    select "High", from: "優先度"
    fill_in "タグ (カンマ区切り)", with: "shared,playwright"
    click_on "保存"
    expect(page).to have_text("Todo was successfully created")

    todo = Todo.last
    visit todo_path(todo)
    find("h3", text: "共有ユーザー", wait: 5)
    within(first("div.card", text: /共有ユーザー/)) do
      fill_in "メールアドレスで共有", with: collaborator.email
      select "編集可", from: "権限"
      click_on "共有追加"
    end
    expect(page).to have_text("共有しました")

    logout

    login_as(collaborator)
    within("form[action='#{todos_path}']") do
      fill_in "タグ", with: "shared"
      click_on "フィルタ"
    end
    expect(page).to have_text("Shared Playwright Todo")

    within("#todos") { click_on "詳細", match: :first }
    expect(page).to have_text("共有ユーザー")

    visit todo_comments_path(todo)
    fill_in "コメントを書く", with: "Looks collaborative!"
    click_on "投稿"

    expect(page).to have_text("Looks collaborative!")
  end

  it "prevents viewer collaborators from editing or commenting" do
    owner = create(:user, password: "password", password_confirmation: "password")
    viewer = create(:user, password: "password", password_confirmation: "password")

    login_as(owner)
    visit new_todo_path
    fill_in "Title", with: "Read-only Todo"
    fill_in "Description", with: "Viewer cannot edit or comment"
    fill_in "締切日", with: (Date.today + 3).to_s
    select "Low", from: "優先度"
    click_on "保存"

    todo = Todo.last
    visit todo_path(todo)
    find("h3", text: "共有ユーザー", wait: 5)
    within(first("div.card", text: /共有ユーザー/)) do
      fill_in "メールアドレスで共有", with: viewer.email
      select "閲覧のみ", from: "権限"
      click_on "共有追加"
    end
    expect(page).to have_text("共有しました")

    logout

    login_as(viewer)
    within("#todos") { click_on "詳細", match: :first }

    visit todo_comments_path(todo)
    fill_in "コメントを書く", with: "Viewer attempt"
    click_on "投稿"
    expect(page).to have_text("コメント権限がありません")

    visit edit_todo_path(todo)
    expect(page).to have_text("編集権限がありません")
  end
end
