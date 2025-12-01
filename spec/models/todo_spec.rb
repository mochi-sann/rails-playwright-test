require "rails_helper"

RSpec.describe Todo, type: :model do
  describe "validations" do
    it "is valid with a title" do
      todo = Todo.new(title: "Write tests", description: "Add RSpec coverage", completed: false)

      expect(todo).to be_valid
    end

    it "is invalid without a title" do
      todo = Todo.new(description: "Missing title", completed: false)

      expect(todo).not_to be_valid
      expect(todo.errors[:title]).to include("can't be blank")
    end
  end
end
