class Admin::HomesController < ApplicationController
  before_action :authenticate_admin!

  def top
    @posts = Post.all
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    flash[:notice] = "投稿を削除しました！"
    redirect_to request.referer
  end
end
