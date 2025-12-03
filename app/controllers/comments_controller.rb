class CommentsController < ApplicationController
  before_action :require_login
  before_action :set_todo
  before_action :ensure_comment_permission, only: :create

  def index
    respond_to do |format|
      format.html { render layout: false }
      format.turbo_stream { render layout: false }
    end
  end

  def create
    @comment = @todo.comments.build(comment_params.merge(user: current_user))
    respond_to do |format|
      if @comment.save
        format.html { redirect_to @todo, notice: "コメントを追加しました" }
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace("comments_frame",
                                                    partial: "comments/comments",
                                                    locals: { todo: @todo },
                                                    formats: [ :html ])
        end
      else
        format.html { redirect_to @todo, alert: @comment.errors.full_messages.to_sentence }
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace("comments_frame",
                                                    partial: "comments/comments",
                                                    locals: { todo: @todo },
                                                    formats: [ :html ]),
                 status: :unprocessable_entity
        end
      end
    end
  end

  private

  def set_todo
    @todo = current_user.accessible_todos.find(params[:todo_id])
  end

  def comment_params
    params.expect(comment: %i[body])
  end

  def ensure_comment_permission
    return if @todo.can_comment?(current_user)

    redirect_to @todo, alert: "コメント権限がありません"
  end
end
