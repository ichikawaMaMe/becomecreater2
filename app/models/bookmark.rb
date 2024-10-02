class Bookmark < ApplicationRecord
    belongs_to :user
    belongs_to :post
    
    def already_bookmarked?(user)
        bookmarks.where(user_id: user.id).exists?
    end 
end
