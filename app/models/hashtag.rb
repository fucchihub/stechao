class Hashtag < ApplicationRecord
  has_many :taggings, dependent: :destroy
  has_many :posts, through: :taggings
  
  validates :name, presence: true, length: { maximum: 99 }
end
