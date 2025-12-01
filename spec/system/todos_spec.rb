require "rails_helper"

RSpec.describe "Todos", type: :system do
  it "shows validation errors when title is blank", skip: "Capybara server socket creation is blocked in this environment" do
    visit new_todo_path

    fill_in "Description", with: "Some description"
    click_on "Create Todo"

    expect(page).to have_text("Title can't be blank")
  end
end
