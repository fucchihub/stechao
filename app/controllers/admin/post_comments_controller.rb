class Admin::PostCommentsController < ApplicationController
  before_action :authenticate_admin!

  def index
    @comments = PostComment.all
  end
  
  def destroy
    @comment = PostComment.find(params[:id])
    @comment.destroy
    flash[:notice] = "コメントを削除しました。"
    redirect_to request.referer
  end
end
