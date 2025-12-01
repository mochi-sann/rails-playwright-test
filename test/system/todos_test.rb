require "application_system_test_case"

class TodosTest < ApplicationSystemTestCase
  setup do
    @todo = todos(:one)
    @user = users(:one)

    visit new_session_path
    fill_in "Email", with: @user.email
    fill_in "Password", with: "password"
    within("form") { click_on "ログイン" }
  end

  test "visiting the index" do
    visit todos_url
    assert_selector "h1", text: "あなたのTodo"
  end

  test "should create todo" do
    visit todos_url
    click_on "新規作成"

    check "Completed" if @todo.completed
    fill_in "Description", with: @todo.description
    fill_in "Title", with: @todo.title
    click_on "保存"

    assert_text "Todo was successfully created"
  end

  test "should update Todo" do
    visit todo_url(@todo)
    click_on "編集", match: :first

    check "Completed" if @todo.completed
    fill_in "Description", with: @todo.description
    fill_in "Title", with: @todo.title
    click_on "保存"

    assert_text "Todo was successfully updated"
  end

  test "should destroy Todo" do
    visit todo_url(@todo)
    click_on "削除", match: :first

    assert_text "Todo was successfully destroyed"
  end

  test "shows validation errors when title is blank" do
    visit new_todo_url

    fill_in "Description", with: "Some description"
    click_on "保存"

    assert_text "Title can't be blank"
  end
end
