require "test_helper"

class TodoTest < ActiveSupport::TestCase
  test "fixture is valid" do
    assert todos(:one).valid?
  end

  test "title is required" do
    todo = Todo.new(description: "missing title",
                    completed: false,
                    due_date: Date.today,
                    priority: :low,
                    user: users(:one))

    assert_not todo.valid?
    assert_includes todo.errors[:title], "can't be blank"
  end
end
