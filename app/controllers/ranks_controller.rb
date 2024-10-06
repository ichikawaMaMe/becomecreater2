class RanksController < ApplicationController
  #投稿がない場合の例外処理を入れること
  def rank
    #ブックマークラング（月）
    @month_bookmark_ranks = Post.find(Bookmark.group(:post_id).where(created_at: Time.current.all_month).order('count(post_id) desc').pluck(:post_id))
    #ブックマークランク（週）
    @week_bookmark_ranks = Post.find(Bookmark.group(:post_id).where(created_at: Time.current.all_week).order('count(post_id) desc').pluck(:post_id))
    #コメント数ランク
    @post_comment_ranks = Post.find(Post_Comment.group(:post_id).order('count(post_id) desc').pluck(:post_id))
    #自分の投稿ver
    @my_post_bookmark_ranks = current_user.posts.sort { |a,b| b.bookmarks.count <=> a.bookmarks.count }

  end
end
