class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  #投稿関連のアソシエーション
  has_many :posts, dependent: :destroy


# フォロー関連
#フォローしたされた関係
has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
#一覧画面
has_many :followings, through: :relationships, source: :followed
has_many :followers, through: :reverse_of_relationships, source: :follower

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

  has_one_attached :profile_image
  has_one_attached :mypageheader_image


  def follow(user_id)
    relationships.create(followed_id: user_id)
  end
  def unfollow(user_id)
    relationships.find_by(followed_id: user_id).destroy
  end
  #def following?(user)
    #followings.include?(user)
 # end

  def get_profile_image(width, height)
    unless profile_image.attached?
      file_path = Rails.root.join('app/assets/images/sample-author1.jpg')
      profile_image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    profile_image.variant(resize_to_limit: [width, height]).processed
  end
  def get_mypageheader_image(width, height)
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
