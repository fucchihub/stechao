class Post < ApplicationRecord

  # 投稿並び替え機能(sorted_by(params))をapp/models/concerns/sortable.rbから呼び出し。
  include Sortable

  has_one_attached :image

  belongs_to :user
  has_many :post_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :taggings, dependent: :destroy
  has_many :hashtags, through: :taggings, dependent: :destroy

  validates :name, presence: true, length: { maximum: 99 }
  validates :quantity, presence: true


  # simple_calenderのstart_timeメソッドの値をcreated_atカラムの値と同じにする。
  def start_time
    created_at
  end


  # userが投稿をお気に入りしているかどうか確認する。
  # userが存在し、かつuser_idがuserのidと一致するレコードがfavorites内にあるときにtrueを返す。
  def favorited_by?(user)
    user.present? && favorites.exists?(user_id: user.id)
  end


  # 投稿画像があればサイズ指定して表示、なければノーイメージ画像を表示する。
  def get_image(width, height)
    unless image.attached?
      file_path = Rails.root.join('app/assets/images/stechao-pale.jpg')
      image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpg')
    end
    image.variant(resize_to_fill: [width, height]).processed
  end


  # 新しいpostが作成された後に、キャプションからハッシュタグを抽出してHashtagモデルに関連付ける。
  after_create do

    # 新しく作成されたpostを取得
    post = Post.find_by(id: self.id)

    # キャプションからハッシュタグ(#で始まり、その後に英数字や日本語が続く)を探してhashtagsに代入。
    hashtags = self.caption.scan(/[#][\w\p{Han}ぁ-ヶｦ-ﾟー]+/)

    # postに関連付けられてるハッシュタグを初期化
    post.hashtags = []

    # ハッシュタグの重複を除いて、残ったハッシュタグに対して繰り返し処理を行う。
    hashtags.uniq.map do |hashtag|

      # hashtagsテーブルにハッシュタグが既に存在する場合はそれを取得し、存在しない場合は新しく作成。
      # その際、ハッシュタグの#をとって小文字に変換する。
      tag = Hashtag.find_or_create_by(name: hashtag.downcase.delete('#'))

      # postとハッシュタグを関連付ける
      post.hashtags << tag
    end

  end


  # postが更新される前に、そのpostのハッシュタグを一旦削除し、新しいキャプションから再度抽出してHashtagモデルに関連付ける。
  # これにより、キャプションが更新された時にハッシュタグも更新される。
  before_update do

    # 更新するpostを取得。
    post = Post.find_by(id: self.id)

    # postに関連付けられてるハッシュタグをクリア（削除）。
    post.hashtags.clear

    # キャプションからハッシュタグ(#で始まり、その後に英数字や日本語が続く)を探してhashtagsに代入。
    hashtags = self.caption.scan(/[#][\w\p{Han}ぁ-ヶｦ-ﾟー]+/)

    # ハッシュタグの重複を除いて、残ったハッシュタグに対して繰り返し処理を行う。
    hashtags.uniq.map do |hashtag|

      # hashtagsテーブルにハッシュタグが既に存在する場合はそれを取得し、存在しない場合は新しく作成。
      # その際、ハッシュタグの#をとって小文字に変換する。
      tag = Hashtag.find_or_create_by(name: hashtag.downcase.delete('#'))

      # postとハッシュタグを関連付ける
      post.hashtags << tag
    end

  end

end
