json.id @user.id
json.name @user.name
json.email @user.email
json.todo_lists @user.todo_lists do |todo_list|
  json.extract! todo_list, :id, :name
end
