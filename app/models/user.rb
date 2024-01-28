class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # 投稿並び替え機能(sorted_by(params))をapp/models/concerns/sortable.rbから呼び出し。
  include Sortable

  has_many :posts, dependent: :destroy
  has_many :post_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy

  validates :name, presence: true, length: { maximum: 20 }
  validates :introduction, length: { maximum: 200 }

  has_one_attached :profile_image


  # プロフィール画像があればサイズ指定して表示、なければノーイメージ画像を表示する。
  def get_profile_image(width, height)
    unless profile_image.attached?
      file_path = Rails.root.join('app/assets/images/stechao-shade.jpg')
      profile_image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpg')
    end
    profile_image.variant(resize_to_fill: [width, height]).processed
  end


  # ユーザがゲストであるかを確認するメソッド。
  def guest?
    self.email == "guest@example.com"
  end


  # ゲストログイン機能。パスワードはランダムに作られる。
  def self.guest
    find_or_create_by!(email: 'guest@example.com') do |user|
      user.password = SecureRandom.urlsafe_base64
      user.name = "ゲスト"
      user.is_active = true
    end
  end

end
