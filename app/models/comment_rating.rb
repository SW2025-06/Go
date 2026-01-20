class CommentRating < ApplicationRecord
  belongs_to :comment
  belongs_to :user

  validates :stars, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 5 }
  validates :helpfulness, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 10 }
end
