class AddUserIdTodoList < ActiveRecord::Migration[7.0]
  def change
    add_column :todo_lists, :user_id, :bigint
    add_foreign_key :todo_lists, :users
  end
end
