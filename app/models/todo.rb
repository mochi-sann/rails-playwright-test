class Todo < ApplicationRecord
  belongs_to :user

  has_many :comments, dependent: :destroy
  has_many :subtasks, dependent: :destroy
  has_many :todo_tags, dependent: :destroy
  has_many :tags, through: :todo_tags
  has_many :todo_collaborations, dependent: :destroy
  has_many :collaborators, through: :todo_collaborations, source: :user

  attr_writer :tag_list

  accepts_nested_attributes_for :subtasks, allow_destroy: true, reject_if: ->(attrs) { attrs["title"].blank? }

  enum :priority, { low: 0, medium: 1, high: 2 }, validate: true

  validates :title, :due_date, :priority, presence: true

  after_commit :sync_tag_list, if: :tag_list_assigned?, on: %i[ create update ]

  def tag_list
    @tag_list.presence || tags.order(:name).pluck(:name).join(", ")
  end

  def tag_names
    tags.order(:name).pluck(:name)
  end

  def role_for(user)
    return nil if user.blank?
    return :owner if user_id == user.id

    todo_collaborations.find_by(user: user)&.role&.to_sym
  end

  def can_edit?(user)
    %i[owner editor manager].include?(role_for(user))
  end

  alias_method :can_comment?, :can_edit?

  def can_share?(user)
    %i[owner manager].include?(role_for(user))
  end

  private

  def sync_tag_list
    names = @tag_list.to_s.split(",").map { |name| name.strip.downcase }.reject(&:blank?).uniq
    self.tags = names.map { |name| Tag.find_or_create_by!(name: name) }
    @tag_list = nil
  end

  def tag_list_assigned?
    defined?(@tag_list)
  end
end
