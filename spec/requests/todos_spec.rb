require "rails_helper"

RSpec.describe "Todos", type: :request do
  describe "POST /todos" do
    it "creates a todo when valid" do
      expect do
        post todos_path, params: { todo: { title: "New Todo", description: "RSpec request spec", completed: false } }
      end.to change(Todo, :count).by(1)

      expect(response).to redirect_to(todo_path(Todo.last))
    end

    it "returns 422 when title is blank" do
      expect do
        post todos_path, params: { todo: { title: "", description: "No title", completed: false } }
      end.not_to change(Todo, :count)

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end
