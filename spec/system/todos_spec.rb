require "rails_helper"

RSpec.describe "Todos", type: :system do
  it "creates a todo successfully" do
    visit root_path

    click_on "New todo"
    fill_in "Title", with: "Write system spec"
    fill_in "Description", with: "Use rack_test driver"
    click_on "Create Todo"

    expect(page).to have_text("Todo was successfully created")
    expect(page).to have_text("Write system spec")
  end

  it "shows validation errors when title is blank" do
    visit new_todo_path

    fill_in "Description", with: "Some description"
    click_on "Create Todo"

    expect(page).to have_text("Title can't be blank")
  end
end
