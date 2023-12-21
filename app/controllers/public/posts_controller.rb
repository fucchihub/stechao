class Public::PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_posts, only: [:index, :hashtag, :filter_by_date]

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
      flash[:error] = "投稿に失敗しました。"
      render :new
    end
  end

  def index
    @posts = Post.all
    set_posts
  end

  def show
    @post = Post.find(params[:id])
    @post_comment = PostComment.new
  end

  def edit
    @post = Post.find(params[:id])
  end

  # モデル内にbefore_updateコールバックあり(ハッシュタグを更新するため)
  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
      flash[:success] = "「#{@post.name.truncate(10)}」を変更しました。"
      redirect_to post_path(@post)
    else
      flash[:danger] = "変更に失敗しました。"
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
    @posts = @hashtag.posts
    set_posts
  end

  # 複数のキーワードで検索できる機能
  def search
    redirect_to request.referer if params[:keyword].nil?

      # 検索フォームから送られてくるキーワードを空白で分割
      split_keyword = params[:keyword].split(/[[:blank:]]+/)
      # 変数の中身を初期化
      @posts = []
      # 分割したキーワードごとに検索
      split_keyword.each do |keyword|
        # キーワードが空白の場合は検索しないでスキップ(空白で検索すると全レコードを取得してしまう)
        next if keyword == ""
        # キーワードが#で始まる場合は#を取り除く(文字列の2文字目から最後までを取り出す)
        keyword = keyword.starts_with?('#') ? keyword[1..-1] : keyword
        # キーワードごとに部分一致検索をし、検索結果のpostを累積して格納（nameとcaption両方から検索）
        @posts += Post.where('name LIKE ? OR caption LIKE ?', "%#{keyword}%", "%#{keyword}%")
      end
      # 重複したpostを削除する
      @posts.uniq!

  end

  # 投稿を日時で絞り込む機能
  def filter_by_date
    @user = current_user
    @posts = @user.posts
    # params[:search_type]が存在する場合はその値を使用し、存在しない場合はデフォルトで "created_at" を設定する
    @search_type = params[:search_type] || "created_at"

    @start_date = params[:start_date].to_date
    @end_date = params[:end_date].to_date

    @filtered_posts = if @search_type == "created_at"
                        @posts.where(created_at: @start_date.beginning_of_day..@end_date.end_of_day)
                      else
                        @posts.where(updated_at: @start_date.beginning_of_day..@end_date.end_of_day)
                      end
  end

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

  def post_params
    params.require(:post).permit(:name, :image, :caption, :quantity, :start_date)
  end
end

# 検索機能
# if params[:filter_by_date]

#       #@posts = @posts.where(...)

#     end

#     if params[:keyword]

#       #@posts = @posts.where( .....)
#     end

#     if params[:order]
#       if params[:order] == 'latest'
#         @posts = @posts.order(created_at: :desc)
#       elsif params[:order] == 'old'
#         @posts = @posts.order(created_at: :asc)
#       elsif params[:order] == 'favorites'
#         @posts = @posts.joins(:favorites).group('posts.id').order('COUNT(favorites.id) DESC') if @posts.present?
#       end
#     end