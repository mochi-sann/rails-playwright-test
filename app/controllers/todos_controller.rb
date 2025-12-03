class TodosController < ApplicationController
  before_action :require_login
  before_action :set_todo, only: %i[ show edit update destroy share ]
  before_action :ensure_edit_permission, only: %i[ edit update destroy ]

  # GET /todos or /todos.json
  def index
    @todos = current_user.accessible_todos.includes(:tags).order(created_at: :desc)

    if params[:status].present?
      case params[:status]
      when "completed"
        @todos = @todos.where(completed: true)
      when "open"
        @todos = @todos.where(completed: false)
      end
    end

    if params[:tag].present?
      tag_name = params[:tag].strip.downcase
      @todos = @todos.joins(:tags).where(tags: { name: tag_name })
    end

    if params[:q].present?
      q = "%#{params[:q]}%"
      @todos = @todos.where("title LIKE :q OR description LIKE :q", q: q)
    end

    @todos = @todos.distinct
  end

  # GET /todos/1 or /todos/1.json
  def show
  end

  # GET /todos/new
  def new
    @todo = current_user.todos.build
  end

  # GET /todos/1/edit
  def edit
  end

  # POST /todos or /todos.json
  def create
    @todo = current_user.todos.build(todo_params)

    respond_to do |format|
      if @todo.save
        format.html { redirect_to @todo, notice: "Todo was successfully created." }
        format.json { render :show, status: :created, location: @todo }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @todo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /todos/1 or /todos/1.json
  def update
    respond_to do |format|
      if @todo.update(todo_params)
        format.html { redirect_to @todo, notice: "Todo was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @todo }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @todo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /todos/1 or /todos/1.json
  def destroy
    @todo.destroy!

    respond_to do |format|
      format.html { redirect_to todos_path, notice: "Todo was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  def share
    unless @todo.can_share?(current_user)
      redirect_to @todo, alert: "共有権限がありません" and return
    end

    attrs = share_params
    target_user = User.find_by(email: attrs[:email])

    if target_user.blank?
      redirect_to @todo, alert: "ユーザーが見つかりません" and return
    end

    collaboration = @todo.todo_collaborations.find_or_initialize_by(user: target_user)
    requested_role = attrs[:role].presence&.to_s
    collaboration.role = TodoCollaboration.roles.key?(requested_role) ? requested_role : :viewer
    if collaboration.save
      redirect_to @todo, notice: "共有しました: #{target_user.email}"
    else
      redirect_to @todo, alert: collaboration.errors.full_messages.to_sentence
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_todo
      @todo = current_user.accessible_todos.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def todo_params
      params.require(:todo).permit(:title, :description, :completed, :due_date, :priority, :tag_list,
                                   subtasks_attributes: %i[id title completed _destroy])
    end

    def share_params
      params.require(:share).permit(:email, :role)
    end

    def ensure_edit_permission
      return if @todo.can_edit?(current_user)

      redirect_to @todo, alert: "編集権限がありません"
    end
end
