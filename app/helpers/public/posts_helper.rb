module Public::PostsHelper

  def render_with_hashtags(caption)

    # キャプションから、#で始まり後に英数字や日本語が続く文字列を探してwordに代入。
    caption.gsub(/[#][\w\p{Han}ぁ-ヶｦ-ﾟー]+/) do |word|
      
      # 各wordをハッシュタグとしてリンクに変換すると同時に、
      # リンクのURLの:nameにもwordを割り当てるようにする。
      # このとき、URLに割り当てるwordだけを小文字に変換する。
      #
      # これにより、#APPLE、#Apple、#appleのように表記が異なっていても、
      # すべてappleという同じURLを持つハッシュタグとして認識されるので、
      # どのハッシュタグを押しても同じ内容の一覧が表示できる。
      link_to word, hashtag_posts_path(name: word.downcase.delete("#"))

      # HTMLタグがエスケープされないようにする。
      # エスケープされるとaタグではなく文字列として表示されてしまう。
    end.html_safe

  end
end
