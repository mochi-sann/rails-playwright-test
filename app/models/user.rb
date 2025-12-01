class User < ApplicationRecord
  has_secure_password

  has_many :todos, dependent: :destroy
  has_many :todo_collaborations, dependent: :destroy
  has_many :shared_todos, through: :todo_collaborations, source: :todo

  validates :email, presence: true, uniqueness: true

  def accessible_todos
    Todo.left_outer_joins(:todo_collaborations)
        .where("todos.user_id = :id OR todo_collaborations.user_id = :id", id: id)
  end
end
