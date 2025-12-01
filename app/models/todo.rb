class Todo < ApplicationRecord
  belongs_to :user

  has_many :comments, dependent: :destroy
  has_many :subtasks, dependent: :destroy

  accepts_nested_attributes_for :subtasks, allow_destroy: true, reject_if: ->(attrs) { attrs["title"].blank? }

  enum :priority, { low: 0, medium: 1, high: 2 }, validate: true

  validates :title, presence: true
end
