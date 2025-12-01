class CommentsController < ApplicationController
  before_action :require_login
  before_action :set_todo

  def create
    @comment = @todo.comments.build(comment_params.merge(user: current_user))
    if @comment.save
      redirect_to @todo, notice: "コメントを追加しました"
    else
      redirect_to @todo, alert: @comment.errors.full_messages.to_sentence
    end
  end

  private

  def set_todo
    @todo = current_user.todos.find(params[:todo_id])
  end

  def comment_params
    params.expect(comment: %i[body])
  end
end
