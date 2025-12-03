require "rails_helper"

RSpec.describe "Users", type: :request do
  it "creates user with Japanese name-like email string and logs in" do
    post users_path, params: {
      user: {
        email: "遊佐ー@example.com",
        password: "password123",
        password_confirmation: "password123"
      }
    }

    expect(response).to redirect_to(todos_path)
    follow_redirect!
    expect(response.body).to include("アカウントを作成しました").or include("ログイン中: 遊佐ー@example.com")
  end
end
