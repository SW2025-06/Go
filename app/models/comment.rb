class Comment < ApplicationRecord
  belongs_to :review
  belongs_to :user

  belongs_to :parent, class_name: "Comment", optional: true
  has_many :replies, class_name: "Comment", foreign_key: :parent_id, dependent: :destroy
  has_many :comment_ratings, dependent: :destroy

  validates :body, presence: true, length: { maximum: 2000 }
end
