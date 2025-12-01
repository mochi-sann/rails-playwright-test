class CreateTodoCollaborations < ActiveRecord::Migration[8.0]
  def change
    create_table :todo_collaborations do |t|
      t.references :user, null: false, foreign_key: true
      t.references :todo, null: false, foreign_key: true

      t.timestamps
    end

    add_index :todo_collaborations, %i[user_id todo_id], unique: true
  end
end
