class PostsController < ApplicationController
  # include Rank

  before_action :authenticate_user!
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :authorize_user, only: [:edit, :update, :destroy]


  def show
    @post = Post.find(params[:id])
    @user = @post.user
    @tags = @post.tags.pluck(:name).join(',')
    @post_comment = PostComment.new
    @post_comments = @post.post_comments.includes(:user)
    @bookmark = @user.bookmarks
    unless Access.where(created_at: Time.zone.now.all_day).find_by(user_id: current_user.id, post_id: @post.id)
      current_user.access.create(post_id: @post.id)
    end
  end

  def new
    @post = Post.new
    @popular_tags = Tag.limit(8)
    @tags = Tag.all
  end

  def create
  @post = current_user.posts.new(post_params)

  # 新規タグの処理（カンマ区切り）
  new_tag_string = params[:post][:new_tags].gsub(/\[|\]/, '')
  new_tag_list = new_tag_string.split(',').map(&:strip)

  # 既存タグの処理
  existing_tag_list = params[:post][:existing_tags] || []

  @post.image.attach(params[:post][:image])

  if @post.save
    # 新規タグと既存タグをそれぞれ保存
    save_tags(@post, new_tag_list + existing_tag_list)
    redirect_to posts_path, success: t('posts.create.create_success')
  else
    @popular_tags = Tag.limit(8)
    @tags = Tag.all
    render :new, status: :unprocessable_entity
  end
  end

  def edit
    @post = Post.find(params[:id])
    @tags = @post.tags.pluck(:name).join(',')
    @popular_tags = Tag.limit(8)
    @all_tags = Tag.all
  end

  def update
    @post = Post.find(params[:id])
    tags = params[:post][:tag_ids].split(',')
    if @post.update(post_params)
      @post.update_tags(tags)
      redirect_to homes_path, success: t('posts.edit.edit_success')
    else
      @popular_tags = Tag.limit(8)
      @all_tags = Tag.all
      render :edit
    end
  end

  def index
    @posts = params[:tag_id].present? ? Tag.find(params[:tag_id]).posts : Post.all
    to = Time.current.at_end_of_day
    from = (to - 6.days).at_beginning_of_day
    @posts = Post.all.sort do |a, b|
      b.bookmarks.where(created_at: from...to).size <=>
      a.bookmarks.where(created_at: from...to).size
    end
    @post = Post.new
    ranking
  end

  def tags
    @tags = Tag.all
  end

  def destroy
    post = Post.find(params[:id])
    post.destroy
    redirect_to homes_path, success: t('posts.destroy.destroy_success')
  end


  private

  def post_params
        params.require(:post).permit(:title, :tags, :caption, :tag_id, :post_time, :publication_range, :status, :image, :visibility, :tag_names, :description)
  end

  def save_tags(post, tag_list)
  tag_list.each do |tag_name|
    next if tag_name.blank? # 空のタグ名を無視
    tag = Tag.find_or_create_by(name: tag_name) # タグが既に存在する場合は取得、存在しない場合は作成
    post.tags << tag unless post.tags.include?(tag) # 投稿にタグを関連付ける（重複を避ける）
  end
  end

  def set_post
    @post = Post.find(params[:id])
  end


  def authorize_user
    redirect_to root_path, alert: "権限がありません" unless @post.user == current_user
  end


  def ranking
    @month_bookmark_ranks = Post.joins(:bookmarks)
                            .where(bookmarks: { created_at: Time.current.all_month })
                            .group(:id)
                            .order('count(bookmarks.id) desc')
                            .limit(3)

    @week_bookmark_ranks = Post.joins(:bookmarks)
                            .where(bookmarks: { created_at: Time.current.all_week })
                            .group(:id)
                            .order('count(bookmarks.id) desc')
                            .limit(3)

    @post_comment_ranks = Post.joins(:post_comments)
                          .group(:id)
                          .order('count(post_comments.id) desc')
                          .limit(3)
  end

end
