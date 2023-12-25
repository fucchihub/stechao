class Public::UsersController < ApplicationController
  before_action :authenticate_user!

  # sorted_by(params)は投稿並び替え機能(app/models/concerns/sortable.rbとモデルに記載)

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.sorted_by(params)
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:success] = "プロフィールを変更しました。"
      redirect_to user_path(@user)
    else
      flash.now[:error] = "変更に失敗しました。"
      render :edit
    end
  end

  # お気に入りを一覧表示する機能
  def favorites
    @user = User.find(params[:id])
    # favoritesテーブルから@user.idが一致するレコードを取得し、その中からpost_idカラムだけ取得
    favorites= Favorite.where(user_id: @user.id).pluck(:post_id)
    # 取得したpost_idを使ってuserがお気に入りした投稿を見つける
    @posts = Post.where(id: favorites).sorted_by(params)
  end

  def withdraw
    current_user.update(is_active: false)
    reset_session
    flash[:notice] = "ご利用ありがとうございました。"
    redirect_to root_path
  end

  private

  def user_params
    params.require(:user).permit(:name, :profile_image, :introduction, :email)
  end
end
