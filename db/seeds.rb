# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
User.transaction do
  user = User.find_or_create_by!(email: "demo@example.com") do |u|
    u.password = "password"
    u.password_confirmation = "password"
  end

  puts "Seed user: #{user.email} / password"

  todo1 = user.todos.find_or_create_by!(title: "レポート作成") do |t|
    t.description = "週次レポートをまとめる"
    t.completed = false
    t.due_date = Date.today + 2.days
    t.priority = :high
    t.tag_list = "work,report"
  end

  todo2 = user.todos.find_or_create_by!(title: "買い出し") do |t|
    t.description = "牛乳とパンを忘れずに"
    t.completed = false
    t.due_date = Date.today + 1.day
    t.priority = :medium
    t.tag_list = "home,errand"
  end

  todo3 = user.todos.find_or_create_by!(title: "読書") do |t|
    t.description = "積読を1冊消化"
    t.completed = true
    t.due_date = Date.today - 1.day
    t.priority = :low
    t.tag_list = "personal"
  end

  todo1.subtasks.find_or_create_by!(title: "資料集め")
  todo1.subtasks.find_or_create_by!(title: "下書き")
  todo2.subtasks.find_or_create_by!(title: "スーパーへ行く")

  todo1.comments.find_or_create_by!(user: user, body: "火曜までにドラフト提出")
  todo2.comments.find_or_create_by!(user: user, body: "割引クーポンを使う")
end
