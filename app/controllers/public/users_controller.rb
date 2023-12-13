class Public::UsersController < ApplicationController
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
      flash[:danger] = "変更に失敗しました"
      render :edit
    end
  end

  # お気に入りを一覧表示する機能
  def favorites
    @user = User.find(params[:id])
    # favoritesテーブルから@user.idが一致するレコードを取得し、その中からpost_idカラムだけ取得
    favorites= Favorite.where(user_id: @user.id).pluck(:post_id)
    # 取得したpost_idを使ってuserがお気に入りした投稿を見つける
    @favorite_posts = Post.find(favorites)
  end

  private

  def user_params
    params.require(:user).permit(:name, :profile_image, :introduction, :email)
  end
end
