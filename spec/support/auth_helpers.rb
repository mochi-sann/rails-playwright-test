module AuthHelpers
  def sign_in(user, password: "password")
    post session_path, params: { session: { email: user.email, password: password } }
  end
end
