class BookmarksController < ApplicationController
    def create
        bookmark = current_user.bookmarks.build(post_id: params[:post_id])
        bookmark.save
    end
    def destroy
        bookmark = Bookmark.find_by(post_id: params[:post_id], user_id: current_user.id)
        bookmark.destroy
    end
end
