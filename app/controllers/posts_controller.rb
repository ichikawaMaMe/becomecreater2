class PostsController < ApplicationController
    def show
        @post = Post.find(params[:id])
        @user = User.find(params[:id])
        @post_comment = PostComment.new
        @bookmark = @user.bookmark
        unless Access.where(created_at: Time.zone.now.all_day).find_by(user_id: current_user.id, post_id: @post.id)
        current_user.access.create(post_id: @post.id)
        end

    end
    def new
        @post = Post.new

    end
    def create
        @post = current_user.posts.new(post_params)
        tags = params[:post][:tag_id].split(',')
        if @post.save
            @post.save_tags(tags)
            redirect_to homes_path, success: t('posts.create.create_success')   #投稿完了後、投稿詳細に移動する。後ほど修正する。
        else
            render :new
        end
    end
    def edit
        @post = Post.find(params[:id])
        @tags = @post.tags.pluck(:name).join(',')
    end
    def update
        @post = Post.find(params[:id])
        tags = params[:post][:tag_id].split(',')
        if @post.update(post_params)
            @post.update_tags(tags)
            redirect_to homes_path, success: t('posts.edit.edit_success')    #投稿編集後、投稿詳細に移動する。後ほど修正する。
        else
            render :edit
        end
    end
    def destroy
        post = Post.find(params[:id])
        post.destroy
        redirect_to homes_path, success: t('posts.destroy.destroy_success')    #投稿編集後、投稿詳細に移動する。後ほど修正する。
    end
    #ストロングパラメーター
    private

    def post_params
        params.require(:post).permit(:title, :caption, :tag_id, :post_time, :publication_range, :status, :image)
    end
end
