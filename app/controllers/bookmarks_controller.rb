class BookmarksController < ApplicationController

  before_action :set_post

    def create
        @bookmark = current_user.bookmarks.build(post_id: @post.id)

        if @bookmark.save
          flash[:success] = "ブックマークを追加しました"

          redirect_back_or_post
        else
          flash[:error] = "ブックマークに失敗しました"
          redirect_back_or_post
        end
    end

    def destroy
        @bookmark = Bookmark.find_by(post_id: @post.id, user_id: current_user.id)
        if @bookmark&.destroy
          flash[:success] = "ブックマークを削除しました"
          redirect_back_or_post
        else
          flash[:error] = "ブックマークの削除に失敗しました"
          redirect_back_or_post
        end
    end

    private

    def set_post
      @post = Post.find(params[:post_id])
    end

    def redirect_back_or_post
      if request.referer&.include?(post_path(@post))
        redirect_to post_path(@post)
      elsif request.referer&.include?(posts_path)
        redirect_to posts_path
      else
        redirect_to posts_path # デフォルトのリダイレクト先
      end
    end

end
