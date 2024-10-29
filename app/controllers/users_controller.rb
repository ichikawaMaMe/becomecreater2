class UsersController < ApplicationController
    before_action :set_user, only: [:edit, :update]

  def show
    Rails.logger.debug("Current User: #{current_user.inspect}")
    @user = User.find(params[:id])
    #@post = @user.posts.page(params[:page])
    @bookmarked_posts = @user.bookmarked_posts
    @posts = @user.posts.includes(:bookmarks)
    render 'mypage'
  end
   def edit
     @user = User.find(params[:id])
   end

   def update
     if @user.update(user_params)
      redirect_to user_path(@user), notice: 'プロフィールが更新されました。'
     else
      render :edit, status: :unprocessable_entity
     end
   end

   private

  def set_user
    @user = User.find(params[:id])
  end

   def user_params
     params.require(:user).permit(:name, :profile_image, :introduction, :mypageheader_image, :email, :password, :password_confirmation)
   end


end
