class HomesController < ApplicationController
    def top
    to = Time.current.at_end_of_day
    from = (to - 6.days).at_beginning_of_day

    # 投稿をブックマーク数でソートし、トップ5を取得
    @top_ranked_posts = Post.all.sort_by do |post|
      post.bookmarks.where(created_at: from...to).size
    end.reverse.first(3)
    end

    def about
    end

    def index
        @posts = Post.all
    end
end
