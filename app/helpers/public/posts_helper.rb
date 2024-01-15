module Public::PostsHelper
  
  def render_with_hashtags(caption)
    
    # キャプション内で正規表現に一致する文字列を探してwordに代入。
    # 正規表現とは #で始まり、その後に英数字や日本語が続く文字列のこと。
    caption.gsub(/[#][\w\p{Han}ぁ-ヶｦ-ﾟー]+/) do |word|
      
      # 各wordをハッシュタグ名としてリンクに変換する。その際、
      # ハッシュタグ名を小文字に変換し、リンクのURLの:nameに割り当てるようにする。
      # これはハッシュタグのcreate・update時に
      # これにより、投稿の新規作成・編集時にハッシュタグを大文字で入力していても、
      # 投稿されたら小文字で表示されるようになる。
      # もし大小が違っているとハッシュタグのnameカラムの値と一致しなくなる）
      link_to word, hashtag_posts_path(name: word.downcase.delete("#"))
      
      # HTMLタグがエスケープされないようにする。(エスケープされるとaタグではなく文字列として表示されてしまう)
    end.html_safe
    
  end
end
