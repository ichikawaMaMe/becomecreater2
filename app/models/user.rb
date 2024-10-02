class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         
  #投稿関連のアソシエーション
  has_many :posts, dependent: :destroy
  
  has_many :relatnionships#, dependent: :destroy
  has_many :followings, through: :relationships, source: :follower
  
  has_many :passive_relationships, class_name: 'Relationship', foreign_key: 'follower_id'#, dependent: :destroy
  has_many :followers, through: :passive_relationships, source: :user
  
  #DM関連のアソシエーション
  has_many :user_dmroom, dependent: :destroy
  has_many :dms, dependent: :destroy
  
  #閲覧数関連のアソシエーション
  has_many :access
  
  #ブックマーク関連のアソシエーション
  has_many :bookmarks
  has_many :bookmark_post, through: :bookmarks, source: :post
  
  #コメント関連のアソシエーション
  has_many :post_comments, dependent: :destroy
  
  def follow(other_user)
    return if self == other_user
    relationshops.find_or_create_by!(follower: other_user)
  end 
  def following?(user)
    followings.include?(user)
  end 
  def unfollow(relationship_id)
    relationshops.find(relationshop_id).destroy!
  end 
  def get_pforile_image
    unless profile_image.attached?
      file_path = Rails.root.join('app/assets/images/sample-author1.jpg')
      profile_image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end 
    profile_image.variant(resize_to_limit: [width, height]).processed
  end 
  def get_mypageheader_image
    unless mypageheader_image.attached?
      file_path = Rails.root.join('app/assets/images/sample-author1.jpg')
      mypageheader_image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end 
    mypageheader_image.variant(resize_to_limit: [width, height]).processed
  end 
  
  def self.search_for(content, method)
    if method == 'perfect'
      User.where(name: content)
    else
      User.where('name LIKE ?', '%' + content + '%')
    end 
  end 
end
