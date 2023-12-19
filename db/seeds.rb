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

  5.times do |n|
    user = User.create!(
      name: "stechaoユーザー#{n + 1}",
      email: "stechao#{n + 1}@stechao.com",
      password: "ssssss"
    )

    4.times do |m|
      Post.create!(
        user_id: user.id,
        name: "投稿#{n * 4 + m + 1}",
        caption: "#投稿 説明#{n * 4 + m + 1}"
      )
    end
      # １回目は0*4+0+1=1～0*4+3+1=4、２回目は1*4+0+1=5～1*4+3+1=8、、、となり、
      # ユーザー１の投稿は投稿1～4、ユーザー２の投稿は投稿5～8、、、となる。

  end