class Game < ApplicationRecord
    has_many :reviews, dependent: :destroy
    
    #validates :title, presence: true
    #validates :platform, presence: true
    #validates :genre, presence: true
end
