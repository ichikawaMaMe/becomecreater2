class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    #@post = @user.posts.page(params[:page])
    render 'mypage'
  end
   def edit
     @user = User.find(params[:id])
   end
   def update
     @user = User.find(params[:id])
     @user.update(user_params)
     redirect_to user_path(@user)
   end

   private

  # def user_params
     #params.requier(:user).permit(:name, :profile_image, :profile ,:profile_image )
   #end

end
