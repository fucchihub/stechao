class Public::PostsController < ApplicationController
  before_action :authenticate_user!

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.new(post_params)
    if @post.save
      flash[:success] = "#{params[:name].truncate(10)}を投稿しました！"
      redirect_to post_path(@post)
    else
      flash[:error] = "投稿できませんでした..."
      render :new
    end
  end

  def index
    @posts = Post.all
  end

  def show
    @post = Post.find(params[:id])
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    flash[:notice] = "投稿を削除しました！"
    redirect_to posts_path
  end

  private

  def post_params
    params.require(:post).permit(:name, :image, :caption, :quantity)
  end
end
