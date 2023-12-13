class Hashtag < ApplicationRecord
  has_many :taggings, dependent: :destroy
  has_many :posts, through: :taggings
  
  validates :hashname, presence: true, length: { maximum: 99 }
end
