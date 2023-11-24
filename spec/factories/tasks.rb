FactoryBot.define do
  factory :task do
    title { '登録表示テスト' }
    content { '登録表示のテスト内容' }
    deadline_on { '2025-02-18' }
    priority { '中' }
    status { '未着手' }
    user
  end

  factory :second_task, class: Task do
    title { '書類作成' }
    content { '企画書を作成する。' }
    deadline_on { '2025-02-17' }
    priority { '高' }
    status { '着手中' }
    user
  end

  factory :third_task, class: Task do
    title { '詳細テスト' }
    content { '詳細表示のテスト内容' }
    deadline_on { '2025-02-16' }
    priority { '中' }
    status { '完了' }
    user
  end
end