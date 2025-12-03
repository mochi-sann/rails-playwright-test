require "rails_helper"

RSpec.describe Todo, type: :model do
  let(:user) { create(:user) }

  describe "validations" do
    it "is valid with a title" do
      todo = build(:todo, title: "Write tests",
                          description: "Add RSpec coverage",
                          completed: false,
                          user: user,
                          due_date: Date.current,
                          priority: :medium)

      expect(todo).to be_valid
    end

    it "is invalid without a title" do
      todo = build(:todo, title: nil, description: "Missing title", completed: false, user: user,
                          due_date: Date.current, priority: :low)

      expect(todo).not_to be_valid
      expect(todo.errors[:title]).to include("can't be blank")
    end
  end

  describe "associations" do
    it "can have comments and subtasks" do
      todo = create(:todo, title: "With relations", user: user, due_date: Date.current, priority: :low)
      todo.comments.create!(body: "Nice", user: user)
      todo.subtasks.create!(title: "Step 1")

      expect(todo.comments.count).to eq(1)
      expect(todo.subtasks.count).to eq(1)
    end
  end
end
