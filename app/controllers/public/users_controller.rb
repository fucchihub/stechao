class Public::UsersController < ApplicationController
  before_action :authenticate_user!

  # sorted_by(params)は投稿並び替え機能(app/models/concerns/sortable.rbとモデルに記載)


  def index
    # 有効なユーザの投稿だけ表示
    @users = User.where(is_active: true)
  end


  def show
    @user = User.find_by(id: params[:id])

    if @user.nil?
      flash[:error] = "ページが存在しません。"
      redirect_to posts_path

    elsif !@user.is_active
      flash[:error] = "アクセスが無効です。"
      redirect_to posts_path

    else
      @posts = @user.posts.sorted_by(params)
    end
  end


  def edit
    @user = User.find_by(id: params[:id])

    if @user.nil?
      flash[:error] = "ページが存在しません。"
      redirect_to posts_path

    elsif @user != current_user
      flash[:error] = "禁止された操作です。"
      redirect_to posts_path
    end
  end


  def update
    @user = User.find(params[:id])

    if @user.update(user_params)
      flash[:success] = "プロフィールを変更しました。"
      redirect_to user_path(@user)

    else
      flash.now[:alert] = "変更に失敗しました。"
      render :edit
    end
  end


  # お気に入りを一覧表示する機能
  def favorites
    @user = User.find(params[:id])

    # favoritesテーブルから@user.idが一致するレコードを取得し、その中からpost_idカラムだけ取得
    favorites= Favorite.where(user_id: @user.id).pluck(:post_id)

    # 取得したpost_idを使ってuserがお気に入りした投稿を見つける
    @posts = Post.where(id: favorites)

    # 有効なユーザの投稿だけ表示
    active_user_ids = User.where(is_active: true).pluck(:id)
    @posts = @posts.where(user_id: active_user_ids).sorted_by(params)
  end


  # 退会機能（ステータスが退会となるだけで削除はされない）
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
