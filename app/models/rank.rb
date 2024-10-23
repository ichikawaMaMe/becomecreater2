class Rank < ApplicationRecord
    belongs_to :user
    belongs_to :post


  module Rank
   def ranking
    #ブックマークラング（月）
    @month_bookmark_ranks = Post.joins(:bookmarks)
                            .where(bookmarks: { created_at: Time.current.all_month })
                            .group(:id)
                            .order('count(bookmarks.id) desc')
                            .limit(3)

    #ブックマークランク（週）
    @week_bookmark_ranks = Post.joins(:bookmarks)
                            .where(bookmarks: { created_at: Time.current.all_week })
                            .group(:id)
                            .order('count(bookmarks.id) desc')
                            .limit(3)
    #コメント数ランク
    @post_comment_ranks =  Post.joins(:post_comments)
                            .group(:id)
                            .order('count(post_comments.id) desc')
                            .limit(3)
    #自分の投稿ver
    @my_post_bookmark_ranks = current_user.posts.sort { |a,b| b.bookmarks.count <=> a.bookmarks.count }
   end
  end
end
