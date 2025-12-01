require "rails_helper"

RSpec.describe "End-to-end: Todo flow", type: :system do
  it "creates a todo with priority/tags/due date and adds a comment" do
    email = "e2e_#{SecureRandom.hex(4)}@example.com"

    visit new_user_path
    fill_in "Email", with: email
    fill_in "Password", with: "password123"
    fill_in "Password confirmation", with: "password123"
    click_on "アカウント作成"

    expect(page).to have_button("ログアウト")

    visit new_todo_path
    fill_in "Title", with: "E2E Todo"
    fill_in "Description", with: "Playwright-ready flow"
    fill_in "締切日", with: (Date.today + 7).to_s
    select "High", from: "優先度"
    fill_in "タグ (カンマ区切り)", with: "e2e,playwright"

    # サブタスク1件目
    within("#subtasks") do
      find("input[name$='[title]']").set("First step")
    end
    click_on "保存"

    expect(page).to have_text("Todo was successfully created")
    expect(page).to have_text("E2E Todo")
    expect(page).to have_text("High")
    expect(page).to have_text("e2e,playwright")

    todo = Todo.order(created_at: :desc).first
    expect(todo.subtasks.pluck(:title)).to include("First step")

    fill_in "コメントを書く", with: "Looks good"
    click_on "投稿"

    expect(page).to have_text("コメントを追加しました").or have_text("Looks good")
  end
end
