module Public::PostsHelper
  def render_with_hashtags(caption)
    # キャプション内で正規表現(#で始まり、その後に英数字や日本語が続く文字列)に一致する文字列(ハッシュタグ)を検索。
    caption.gsub(/[#][\w\p{Han}ぁ-ヶｦ-ﾟー]+/) do |word|
      # word(ハッシュタグ)ごとにリンクに変換。
      # その際、大文字を小文字に変換して、ハッシュタグ名をリンクのパスに含める。
      # （新規投稿時に大で入力しても小に変換されるようになる。もし大小が違っているとハッシュタグのnameカラムの値と一致しなくなる）
      link_to word.downcase, hashtag_posts_path(name: word.downcase.delete("#"))
      # HTMLタグがエスケープされないようにする。(エスケープされるとaタグではなく文字列として表示されてしまう)
    end.html_safe
  end
end
