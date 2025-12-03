require "rails_helper"

RSpec.describe "Todos", type: :request do
  let(:user) { create(:user) }

  before { sign_in(user) }

  describe "POST /todos" do
    let(:valid_payload) do
      {
        title: "New Todo",
        description: "RSpec request spec",
        completed: false,
        due_date: Date.current + 1.day,
        priority: :high,
        tag_list: "work"
      }
    end

    it "creates a todo when valid" do
      expect do
        post todos_path, params: { todo: valid_payload }
      end.to change(Todo, :count).by(1)

      expect(response).to redirect_to(todo_path(Todo.last))
    end

    it "returns 422 when title is blank" do
      expect do
        post todos_path, params: { todo: valid_payload.merge(title: "") }
      end.not_to change(Todo, :count)

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "filtering" do
    before do
      create(:todo, user: user, title: "Open", completed: false, due_date: Date.current + 1.day, priority: :low)
      create(:todo, user: user, title: "Done", completed: true, due_date: Date.current + 1.day, priority: :low)
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
    let(:other_user) { create(:user) }

    it "shares todo with another user" do
      todo = create(:todo, user: user, title: "Share target", due_date: Date.current + 2.days, priority: :medium)

      expect do
        post share_todo_path(todo), params: { share: { email: other_user.email, role: :viewer } }
      end.to change(TodoCollaboration, :count).by(1)

      expect(response).to redirect_to(todo_path(todo))
      follow_redirect!
      expect(response.body).to include(other_user.email)
    end

    it "allows shared user to see in index" do
      todo = create(:todo, user: user, title: "Shared task", due_date: Date.current + 3.days, priority: :medium)
      create(:todo_collaboration, todo: todo, user: other_user, role: :viewer)

      delete session_path
      sign_in(other_user)

      get todos_path
      expect(response.body).to include("Shared task")
    end
  end
end
