class PostCommentsController < ApplicationController
      def create
        @post = Post.find(params[:post_id])
        @post_comment = @post.post_comments.new(post_comment_params)
        @post_comment.user = current_user

        respond_to do |format|
        if @post_comment.save
          format.js
          format.json { render json: @post_comment, status: :created }
            format.html { redirect_to post_path(@post) }

        else
          format.js
          format.json { render json: @post_comment.errors, status: :unprocessable_entity }
            format.html { redirect_to post_path(@post) }

        end
        end
      end


    def destroy
    @post_comment = PostComment.find(params[:id])
    @post = Post.find(params[:post_id])

    if @post_comment.destroy
      respond_to do |format|
        format.json { head :no_content }
        format.html { redirect_to @post, notice: 'コメントを削除しました。' }
      end
    else
      respond_to do |format|
        format.json { render json: { error: '削除に失敗しました。' }, status: :unprocessable_entity }
        format.html { redirect_to @post, alert: '削除に失敗しました。' }
      end
    end
    end

    private

    def post_comment_params
        params.require(:post_comment).permit(:comment)
    end
end
