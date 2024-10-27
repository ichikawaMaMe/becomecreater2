class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_user_images

  def after_sign_in_path_for(resource)
    posts_path   #homeに移動するけど、後ほどルート確認して正しい記述に直しておく
  end
  def after_sign_out_path_for(resource)
    root_path
  end

  #DM関連
  def show
    @user = User.find_by(id: params[:id])
    @current_user_dmroom = Entry.where(user_id: current_user.id)
    @another_user_dmroom = Entry.where(user_id: @user.id)
    unless @user.id == current_user.id
       @current_user_dmroom.each do |current|
         @another_user_dmrooom.each do |another|
           if current.dmroom_id == another.dmroom_id
             @is_room = true
             @room_id = current.dmroom_id
           end
         end
       end
       unless @is_room
         @dmroom = Dmroom.new
         @user_dmroom = User_dmroom.new
       end
    end
  end

  #ブックマーク関連
  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @bookmarks = @user.bookmarks
    @bookmark_posts = @user.bookmark_post
  end

module ApplicationHelper
  def profile_image_for(user)
    if user&.profile_image&.attached?
      user.profile_image.url
    else
      "/assets/images/sample-author1.jpeg"
    end
  end
end


  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end

    def dm_params
        params.require(:dm).permit(:dm, :dmroom_id)
    end
    def reject_non_related
        user = User.find(params[:id])
        unless current_user.following?(user) && user.following?(current_user)
          redirect_to posts_path
        end
    end

 def set_user_images
  if current_user
    @profile_image_url = current_user.profile_image.attached? ? url_for(current_user.profile_image) : "/assets/images/sample-author1.jpeg"
    @mypageheader_image_url = current_user.mypageheader_image.attached? ? url_for(current_user.mypageheader_image) : "/assets/images/sample-author1.jpeg"
  else
    @profile_image_url = "/assets/images/sample-author1.jpeg"
    @mypageheader_image_url = "/assets/images/sample-author1.jpeg"
  end
 end


end

