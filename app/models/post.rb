class Post < ApplicationRecord
  has_one_attached :image

  belongs_to :user
  has_many :post_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :taggings, dependent: :destroy
  has_many :hashtags, through: :taggings, dependent: :destroy

  #validates :name, presence: true, length: { maximum: 20 }

  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

  def get_image(width, height)
    unless image.attached?
      file_path = Rails.root.join('app/assets/images/tibesuna.jpg')
      image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    image.variant(resize_to_fill: [width, height]).processed
  end

  after_create do
  posts = Post.find_by(id: self.id)
  hashtags = self.caption.scan(/[#][\w\p{Han}ぁ-ヶｦ-ﾟー]+/)
  posts.hashtags = []
  hashtags.uniq.map do |hashtag|
    # ハッシュタグは先頭の'#'を外した上で保存
    tag = Hashtag.find_or_create_by(name: hashtag.downcase.delete('#'))
    posts.hashtags << tag
  end
end

before_update do
  # @type [Post]
  posts = Post.find_by(id: self.id)
  posts.hashtags.clear
  hashtags = self.caption.scan(/[#][\w\p{Han}ぁ-ヶｦ-ﾟー]+/)
  hashtags.uniq.map do |hashtag|
    tag = Hashtag.find_or_create_by(name: hashtag.downcase.delete('#'))
    posts.hashtags << tag
  end
end
end
