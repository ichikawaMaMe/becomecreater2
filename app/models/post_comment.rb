class Post_comment < ApplicationRecord
    belongs_to :user
    belongs_to :post
    validates :comment, presence: true
end
