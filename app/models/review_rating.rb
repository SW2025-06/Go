class ReviewRating < ApplicationRecord
  belongs_to :review
  belongs_to :user

  validates :helpfulness, :want_to_play, :recommend_to_friend,
            presence: true,
            numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 10 }
end
