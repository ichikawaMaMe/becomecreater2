class PostCommentsController < ApplicationController
      def create
        post = Post.find(params[:post_id])
        comment = current_user.post_comments.new(post_comment_params)
        comment.post_id = post.id
        if comment.save
            render :post_comments, notice: '投稿完了'
        else
            render 'posts/show'
        end
    end
    def destroy
        PostComment.find_by(id: params[:id], post_id: params[:post_id]).destroy
        redirect_to post_path(params[:post_id]), alert: '削除しました'

        @post = Post.find(params[:post_id])
        render :post_comments
    end

    private

    def post_comment_params
        params.require(:comment).permit(:comment)
    end
end
