require "rails_helper"

RSpec.describe "Todos", type: :request do
  let(:user) { User.create!(email: "user@example.com", password: "password", password_confirmation: "password") }

  before { sign_in(user) }

  describe "POST /todos" do
    it "creates a todo when valid" do
      expect do
        post todos_path, params: { todo: { title: "New Todo", description: "RSpec request spec", completed: false, priority: :high, tags: "work" } }
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

  describe "filtering" do
    before do
      user.todos.create!(title: "Open", completed: false)
      user.todos.create!(title: "Done", completed: true)
    end

    it "filters by status open" do
      get todos_path, params: { status: "open" }
      expect(response.body).to include("Open")
      expect(response.body).not_to include("Done")
    end
  end

  describe "authorization" do
    it "rejects access when not logged in" do
      delete session_path # logout

      get todos_path

      expect(response).to redirect_to(new_session_path)
    end
  end

  describe "sharing" do
    let(:other_user) { User.create!(email: "other@example.com", password: "password", password_confirmation: "password") }

    it "shares todo with another user" do
      todo = user.todos.create!(title: "Share target")

      expect do
        post share_todo_path(todo), params: { share: { email: other_user.email } }
      end.to change(TodoCollaboration, :count).by(1)

      expect(response).to redirect_to(todo_path(todo))
      follow_redirect!
      expect(response.body).to include(other_user.email)
    end

    it "allows shared user to see in index" do
      todo = user.todos.create!(title: "Shared task")
      TodoCollaboration.create!(todo: todo, user: other_user)

      delete session_path
      sign_in(other_user)

      get todos_path
      expect(response.body).to include("Shared task")
    end
  end
end
