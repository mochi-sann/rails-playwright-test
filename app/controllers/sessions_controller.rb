class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by(email: params.dig(:session, :email))

    if user&.authenticate(params.dig(:session, :password))
      session[:user_id] = user.id
      redirect_to todos_path, notice: "ログインしました"
    else
      flash.now[:alert] = "メールアドレスまたはパスワードが正しくありません"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session.delete(:user_id)
    redirect_to new_session_path, notice: "ログアウトしました"
  end
end
