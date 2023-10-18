class User < ApplicationRecord
  before_destroy :check_last_admin
  before_update :check_last_admin
  
  before_validation { email.downcase! }
  has_secure_password
  validates :name, presence: true
  validates :email, presence: true
  validates :email, uniqueness: true
  validates :password, presence: true, length: { minimum: 6, message: "は6文字以上で入力してください" }
  validates :password_confirmation, presence: true
  validate :password_confirmation_matches

  has_many :tasks, dependent: :destroy

  def destroy_with_tasks
    self.destroy
  end

  def task_total
    tasks.count
  end
  
  private

  def password_confirmation_matches
    if password.present? && password_confirmation.present? && password != password_confirmation
      errors.add(:password_confirmation, "とパスワードの入力が一致しません")
    end
  end

  def check_last_admin
    if admin? && User.where(admin: true).count <= 1
      errors.add(:base, '管理者が0人になるため削除できません')
      throw :abort
    end
  end

end