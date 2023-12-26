module Sortable
  extend ActiveSupport::Concern

  class_methods do

    # 投稿を新しい順、古い順、お気に入りが多い順で並び替える機能
    def sorted_by(params)
      if params[:latest]
        order(created_at: :desc)
      elsif params[:old]
        order(created_at: :asc)
      elsif params[:most_favorites]
        joins(:favorites).group('posts.id').order('COUNT(favorites.id) DESC')
      else
        order(created_at: :desc)
      end
    end

  end

end