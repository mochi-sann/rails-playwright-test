class AddDetailsToTodos < ActiveRecord::Migration[8.0]
  def change
    add_column :todos, :due_date, :date
    add_column :todos, :priority, :integer, default: 0, null: false
    add_column :todos, :tags, :string
  end
end
