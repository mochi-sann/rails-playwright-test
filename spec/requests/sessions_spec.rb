require "rails_helper"

RSpec.describe "Sessions", type: :request do
  let!(:user) { User.create!(email: "user@example.com", password: "password", password_confirmation: "password") }

  it "logs in with valid credentials" do
    post session_path, params: { session: { email: user.email, password: "password" } }

    expect(response).to redirect_to(todos_path)
    follow_redirect!
    expect(response.body).to include("ログインしました").or include("あなたのTodo")
  end

  it "rejects invalid credentials" do
    post session_path, params: { session: { email: user.email, password: "wrong" } }

    expect(response).to have_http_status(:unprocessable_entity)
    expect(response.body).to include("メールアドレスまたはパスワードが正しくありません")
  end
end
