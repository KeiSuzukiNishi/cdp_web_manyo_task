class Task < ApplicationRecord
    validates :title, presence: true
    validates :content, presence: true
    validates :deadline_on, presence: true
    validates :priority, presence: true
    validates :status, presence: true

    enum priority: { "低": 0, "中": 1, "高": 2 }
    enum status: { "未着手": 0, "着手中": 1, "完了": 2 }

    paginates_per 10

    scope :sorted_by_deadline, -> { order(deadline_on: :asc) }
    scope :sorted_by_priority, -> { order(priority: :desc) }
    scope :sorted_by_created_at, -> { order(created_at: :desc) }
  
    scope :search_title, ->(title) { where("title LIKE ?", "%#{title}%") }
    scope :search_status, ->(status) { where(status: statuses[status]) }

    belongs_to :user
end


