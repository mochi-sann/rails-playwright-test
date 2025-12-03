class CreateSubtasks < ActiveRecord::Migration[8.0]
  def change
    create_table :subtasks do |t|
      t.references :todo, null: false, foreign_key: true
      t.string :title, null: false
      t.boolean :completed, default: false, null: false

      t.timestamps
    end
  end
end
