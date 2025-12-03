class EnforceTodoConstraints < ActiveRecord::Migration[8.0]
  def up
    execute <<~SQL.squish
      UPDATE todos
      SET title = 'Untitled Todo'
      WHERE title IS NULL OR title = ''
    SQL
    change_column_null :todos, :title, false

    execute <<~SQL.squish
      UPDATE todos
      SET completed = 0
      WHERE completed IS NULL
    SQL
    change_column_default :todos, :completed, from: nil, to: false
    change_column_null :todos, :completed, false

    execute <<~SQL.squish
      UPDATE todos
      SET priority = 0
      WHERE priority IS NULL
    SQL
    change_column_default :todos, :priority, from: nil, to: 0
    change_column_null :todos, :priority, false

    execute <<~SQL.squish
      UPDATE todos
      SET due_date = CURRENT_DATE
      WHERE due_date IS NULL
    SQL
    change_column_default :todos, :due_date, -> { "CURRENT_DATE" }
    change_column_null :todos, :due_date, false
  end

  def down
    change_column_null :todos, :due_date, true
    change_column_default :todos, :due_date, nil

    change_column_null :todos, :priority, true
    change_column_default :todos, :priority, from: 0, to: nil

    change_column_null :todos, :completed, true
    change_column_default :todos, :completed, from: false, to: nil

    change_column_null :todos, :title, true
  end
end
