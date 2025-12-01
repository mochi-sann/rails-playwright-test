require "rails_helper"

RSpec.describe Todo, type: :model do
  let(:user) { User.create!(email: "user@example.com", password: "password", password_confirmation: "password") }

  describe "validations" do
    it "is valid with a title" do
      todo = Todo.new(title: "Write tests", description: "Add RSpec coverage", completed: false, user: user)

      expect(todo).to be_valid
    end

    it "is invalid without a title" do
      todo = Todo.new(description: "Missing title", completed: false, user: user)

      expect(todo).not_to be_valid
      expect(todo.errors[:title]).to include("can't be blank")
    end
  end
end
