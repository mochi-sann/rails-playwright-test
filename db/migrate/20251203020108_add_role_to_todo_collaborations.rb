class AddRoleToTodoCollaborations < ActiveRecord::Migration[8.0]
  def up
    add_column :todo_collaborations, :role, :integer, null: false, default: 0
    execute <<~SQL.squish
      UPDATE todo_collaborations
      SET role = 1
    SQL
  end

  def down
    remove_column :todo_collaborations, :role
  end
end
