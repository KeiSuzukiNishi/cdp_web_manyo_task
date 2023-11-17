# 一般ユーザーのデータ
User.create!(
  name: "一般ユーザー",
  email: "user@example.com",
  password: "password",
  password_confirmation: "password"
  admin: false
)

# 管理者ユーザーのデータ
User.create!(
  name: "管理者",
  email: "admin@example.com",
  password: "adminpassword",
  password_confirmation: "adminpassword"
  admin: true
)

50.times do
  Task.create!(
    title: "一般ユーザータスク",
    content: "一般ユーザータスクの詳細",
    deadline_on: Date.today + rand(1..30).days,
    priority: Task.priorities.keys.sample,
    status: Task.statuses.keys.sample,
    user: user  # 一般ユーザーに関連づけ
  )
end

# タスクの生成（管理者ユーザーに関連づけ）
50.times do
  Task.create!(
    title: "管理者タスク",
    content: "管理者タスクの詳細",
    deadline_on: Date.today + rand(1..30).days,
    priority: Task.priorities.keys.sample,
    status: Task.statuses.keys.sample,
    user: admin  # 管理者ユーザーに関連づけ
  )
end