# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Admin.create!(
  name: '管理者',
  email: 'z@z',
  password: 'zzzzzz'
)

  4.times do |u|
    user = User.create!(
      name: "stechaoユーザー#{u + 1}",
      email: "stechao#{u + 1}@stechao.com",
      password: "ssssss"
    )

    4.times do |p|
      post = Post.create!(
        user_id: user.id,
        name: "投稿#{u * 4 + p + 1}",
        caption: "#投稿 説明#{u * 4 + p + 1}",
        quantity: 1,
        image: ActiveStorage::Blob.create_and_upload!(io: File.open(Rails.root.join("app/assets/images/post#{u * 4 + p + 1}.jpg")), filename: "post#{u * 4 + p + 1}.jpg")
      )

      3.times do |c|
        PostComment.create!(
          user_id: user.id,
          post_id: post.id,
          comment: "コメント#{u * 3 + p * 3 + c + 1}"
        )
      end
    end

  end

  # 投稿データ作成時、１回目は0*4+0+1=1～0*4+3+1=4、２回目は1*4+0+1=5～1*4+3+1=8、、、となり、
  # ユーザー１の投稿は投稿1～4、ユーザー２の投稿は投稿5～8、、、となる。