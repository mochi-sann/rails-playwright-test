class Comment < ApplicationRecord
  belongs_to :todo
  belongs_to :user

  validates :body, presence: true
end
