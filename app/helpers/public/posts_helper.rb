module Public::PostsHelper
  def render_with_hashtags(caption)
    caption.gsub(/[#][\w\p{Han}ぁ-ヶｦ-ﾟー]+/) do |word|
      link_to word, hashtag_posts_path(name: word.delete("#"))
    end.html_safe
  end
end
