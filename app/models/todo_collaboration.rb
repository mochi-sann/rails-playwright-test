class TodoCollaboration < ApplicationRecord
  belongs_to :user
  belongs_to :todo

  enum :role, { viewer: 0, editor: 1, manager: 2 }, validate: true

  validates :role, presence: true
  validates :todo_id, uniqueness: { scope: :user_id }
end
