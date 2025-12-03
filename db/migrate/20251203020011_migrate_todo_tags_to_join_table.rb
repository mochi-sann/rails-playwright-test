class MigrateTodoTagsToJoinTable < ActiveRecord::Migration[8.0]
  class MigrationTodo < ActiveRecord::Base
    self.table_name = "todos"
  end

  class MigrationTag < ActiveRecord::Base
    self.table_name = "tags"
  end

  class MigrationTodoTag < ActiveRecord::Base
    self.table_name = "todo_tags"
  end

  def up
    return unless column_exists?(:todos, :tags)

    MigrationTodo.reset_column_information
    MigrationTag.reset_column_information
    MigrationTodoTag.reset_column_information

    MigrationTodo.where.not(tags: [ nil, "" ]).find_each do |todo|
      names = todo.tags.to_s.split(",").map { |name| name.strip.downcase }.reject(&:blank?).uniq
      next if names.empty?

      names.each do |name|
        tag = MigrationTag.find_or_create_by!(name: name)
        MigrationTodoTag.find_or_create_by!(todo_id: todo.id, tag_id: tag.id)
      end
    end

    remove_column :todos, :tags, :string
  end

  def down
    add_column :todos, :tags, :string unless column_exists?(:todos, :tags)

    MigrationTodo.reset_column_information
    MigrationTag.reset_column_information
    MigrationTodoTag.reset_column_information

    MigrationTodo.find_each do |todo|
      names = MigrationTag
                .joins("INNER JOIN todo_tags ON todo_tags.tag_id = tags.id")
                .where(todo_tags: { todo_id: todo.id })
                .order("tags.name")
                .pluck(:name)
      next if names.empty?

      todo.update_columns(tags: names.join(","))
    end
  end
end
