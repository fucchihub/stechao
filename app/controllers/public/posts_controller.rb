class Public::PostsController < ApplicationController
  before_action :authenticate_user!

  # sorted_by(params)は投稿並び替え機能(app/models/concerns/sortable.rbとモデルに記載)

  def new
    @post = Post.new
  end

  # postモデル内にafter_createコールバックあり(ハッシュタグを作成するため)
  def create
    @post = current_user.posts.new(post_params)
    if @post.save
      flash[:success] = "投稿しました。"
      redirect_to post_path(@post)
    else
      flash[:alert] = "投稿に失敗しました。"
      render :new
    end
  end

  def index
    # 有効なユーザの投稿だけ表示
    active_user_ids = User.where(is_active: true).pluck(:id)
    @posts = Post.where(user_id: active_user_ids).sorted_by(params)
  end

  def show
    @post = Post.find_by(id: params[:id])
    if @post.nil?
      flash[:error] = "ページが存在しません。"
      redirect_to posts_path
    elsif !@post.user.is_active
      flash[:error] = "アクセスが無効です。"
      redirect_to posts_path
    else
      @post_comment = PostComment.new
    end
  end

  def edit
    @post = Post.find_by(id: params[:id])
    if @post.nil?
      flash[:error] = "ページが存在しません。"
      redirect_to posts_path
    elsif @post.user != current_user
      flash[:error] = "禁止された操作です。"
      redirect_to posts_path
    end
  end

  # モデル内にbefore_updateコールバックあり(ハッシュタグを更新するため)
  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
      flash[:success] = "投稿内容を変更しました。"
      redirect_to post_path(@post)
    else
      flash[:alert] = "変更に失敗しました。"
      render :edit
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    flash[:notice] = "投稿を削除しました。"
    redirect_to user_path(current_user)
  end


  # ハッシュタグ検索機能(ハッシュタグのリンク押すと一覧表示)
  def hashtag
    @user = current_user
    # URLの:nameからハッシュタグの名前を取得
    @hashtag = Hashtag.find_by(name: params[:name])
    # 有効なユーザの投稿だけ表示
    active_user_ids = User.where(is_active: true).pluck(:id)
    @posts = @hashtag.posts.where(user_id: active_user_ids).sorted_by(params)
  end


  # 投稿を複数のキーワードで検索できる機能
  def search
    if params[:keyword] == ""
      flash[:error] = "検索キーワードを入力してください。"
      redirect_to request.referer
    end
    # 検索フォームから送られてくるキーワードを空白で分割
    split_keyword = params[:keyword].split(/[[:blank:]]+/)
    # 変数の中身を空にする
    @posts = Post.none
    split_keyword.each do |keyword|
      # キーワードが空白の場合は検索しないでスキップ(空白で検索すると全レコードを取得してしまう)
      next if keyword == ""
      # キーワードが#で始まる場合は#を取り除く(文字列の2文字目から最後までを取り出す)
      keyword = keyword.starts_with?('#') ? keyword[1..-1] : keyword
      # 「nameとcaption両方からキーワードで部分一致検索」という条件で探したpostを@postsに結合
      @posts = @posts.or(Post.where('name LIKE :keyword OR caption LIKE :keyword', keyword: "%#{keyword}%"))
    end
    # 重複したpostを削除する
    @posts = @posts.distinct
     # 有効なユーザの投稿だけ表示
    active_user_ids = User.where(is_active: true).pluck(:id)
    @posts = @posts.where(user_id: active_user_ids).sorted_by(params)
  end


  # 投稿を日時で絞り込む機能
  def filter_by_date
    @user = current_user
    @posts = @user.posts
    # params[:search_type]が存在する場合はその値を使用し、存在しない場合はデフォルトで "created_at" を設定する
    @search_type = params[:search_type] || "created_at"

    # params[:start_date(end_date)]が存在してかつDate型になっていないならDate型にし、そうでないならそのままparams[]のデータを使う
    @start_date = params[:start_date].presence && !params[:start_date].is_a?(Date) ? params[:start_date].to_date : params[:start_date]
    @end_date = params[:end_date].presence && !params[:end_date].is_a?(Date) ? params[:end_date].to_date : params[:end_date]

    @posts = if @search_type == "created_at"
               @posts.where(created_at: @start_date.beginning_of_day..@end_date.end_of_day)
             else
               @posts.where(updated_at: @start_date.beginning_of_day..@end_date.end_of_day)
             end

     # 有効なユーザの投稿だけ表示
    active_user_ids = User.where(is_active: true).pluck(:id)
    @posts = @posts.where(user_id: active_user_ids).sorted_by(params)
  end

  private

  def post_params
    params.require(:post).permit(:name, :image, :caption, :quantity)
  end
end
