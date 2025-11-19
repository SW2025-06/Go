class Review < ApplicationRecord
  belongs_to :user
  belongs_to :game
  
  has_many :review_tags, dependent: :destroy
  has_many :tags, through: :review_tags
  has_one_attached :image

  #validates :title, :body, :rating, presence: true
  #validates :rating, inclusion: { in: 1..5 }
end
