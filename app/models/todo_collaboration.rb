class TodoCollaboration < ApplicationRecord
  belongs_to :user
  belongs_to :todo

  validates :todo_id, uniqueness: { scope: :user_id }
end
