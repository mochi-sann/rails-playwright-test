class Tag < ApplicationRecord
  has_many :todo_tags, dependent: :destroy
  has_many :todos, through: :todo_tags

  before_validation :normalize_name

  validates :name, presence: true, uniqueness: { case_sensitive: false }

  private

  def normalize_name
    self.name = name.to_s.strip.downcase
  end
end
