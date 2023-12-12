class Public::FavoritesController < ApplicationController
  def create
    @post = PostImage.find(params[:post_id])
    favorite = current_user.favorites.new(post_id: @post.id)
    favorite.save
    redirect_to post_path(@post)
  end

  def destroy
    @post = PostImage.find(params[:post_id])
    favorite = current_user.favorites.new(post_id: @post.id)
    favorite.destroy
    redirect_to post_path(@post)
  end
end
