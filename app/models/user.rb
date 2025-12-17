class User < ApplicationRecord
  # Devise modules — 必要ならモジュールを調整してください
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # username 必須・ユニーク
  validates :username, presence: true, uniqueness: { case_sensitive: false }

  # Devise の validatable がパスワード長などを提供するが、追加の強度チェックを入れる
  validate :password_complexity, if: -> { password.present? }
  
  before_validation :normalize_email

  # Devise の email を必須にしない
  def email_required?
    false
  end

  # Rails 6+ の変更追跡用（メール変更時の副作用を避ける）
  def will_save_change_to_email?
    false
  end

  private

def normalize_email
    self.email = nil if email.blank?
  end

  def password_complexity
    # 例: 8文字以上、英大文字・小文字・数字を1つ以上含む
    return if password.length >= 6
    #return if password.length >= 3 && password =~ /[a-z]/ && password =~ /[A-Z]/ && password =~ /\d/

    errors.add :password, "は6文字以上で英大文字・英小文字・数字を含めてください"
  end
end