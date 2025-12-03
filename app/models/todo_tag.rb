class TodoTag < ApplicationRecord
  belongs_to :todo
  belongs_to :tag

  validates :tag_id, uniqueness: { scope: :todo_id }
end
