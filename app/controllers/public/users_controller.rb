class Public::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_posts, only: [:show]

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:success] = "プロフィールを変更しました！"
      redirect_to user_path(@user)
    else
      flash.now[:danger] = "変更に失敗しました"
      render :edit
    end
  end

  # お気に入りを一覧表示する機能
  def favorites
    @user = User.find(params[:id])
    # favoritesテーブルから@user.idが一致するレコードを取得し、その中からpost_idカラムだけ取得
    favorites= Favorite.where(user_id: @user.id).pluck(:post_id)
    # 取得したpost_idを使ってuserがお気に入りした投稿を見つける
    @posts = Post.find(favorites)
  end

  def withdraw
    current_user.update(is_active: false)
    reset_session
    redirect_to root_path
  end

  # 投稿を新しい順、古い順、お気に入りが多い順で並び替える機能
  def set_posts
    @posts = case
             when params[:latest]
               @posts.order(created_at: :desc) if @posts.present?
             when params[:old]
               @posts.order(created_at: :asc) if @posts.present?
             when params[:most_favorites]
               @posts.joins(:favorites).group('posts.id').order('COUNT(favorites.id) DESC') if @posts.present?
             else
               @posts
             end
  end

  private

  def user_params
    params.require(:user).permit(:name, :profile_image, :introduction, :email)
  end
end
