class Game < ApplicationRecord
    has_many :reviews, dependent: :destroy
    has_one_attached :image
    
    #validates :title, presence: true
    #validates :platform, presence: true
    #validates :genre, presence: true
end
