class Public::FavoritesController < ApplicationController
  before_action :authenticate_user!
  
  # 非同期通信化
  def create
    @post = Post.find(params[:post_id])
    favorite = current_user.favorites.new(post_id: @post.id)
    favorite.save
  end

  # 非同期通信化
  def destroy
    @post = Post.find(params[:post_id])
    favorite = current_user.favorites.find_by(post_id: @post.id)
    favorite.destroy
  end
end
