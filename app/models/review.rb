class Review < ApplicationRecord
  belongs_to :user
  belongs_to :game, optional: true   # 追加（game があるなら）
  has_one_attached :jacket

  has_many :review_ratings, dependent: :destroy
  has_many :comments, dependent: :destroy

  validates :title, presence: true
  validates :body, presence: true
  validates :genre, presence: true
  validates :platform, presence: true

  validate :acceptable_jacket

  private

  def acceptable_jacket
    return unless jacket.attached?

    unless jacket.content_type.in?(%w[image/png image/jpg image/jpeg image/webp])
      errors.add(:jacket, "はPNG/JPG/WebP形式でアップロードしてください")
    end

    if jacket.byte_size > 5.megabytes
      errors.add(:jacket, "は5MB以下にしてください")
    end
  end
end