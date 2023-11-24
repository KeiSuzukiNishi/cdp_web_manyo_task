# ユーザーファクトリー（通常のユーザー）
FactoryBot.define do
  factory :user do
    name { "UserTest" }
    sequence(:email) { |n| "usertest#{n}@example.com" }
    password { "UserTest" }
    password_confirmation { "UserTest" }
    admin { false }
  end
end

# ユーザーファクトリー（管理者ユーザー）
FactoryBot.define do
  factory :admin_user, class: 'User' do
    name { "AdminUserTest" }
    sequence(:email) { |n| "adminusertest#{n}@example.com" }
    password { "AdminUserTest" }
    password_confirmation { "AdminUserTest" }
    admin { true }
  end
end