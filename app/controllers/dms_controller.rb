class DmsController < ApplicationController
    before_action :reject_non_related, only: [:show]

    def create
       @dms = current_user.dms.new(dm_params)
       render :validater unless @dm.save
    end

    def show
        @user = User.find(params[:id])
        rooms = current_user.user_dmrooms.pluck(:room_id)
        user_dmrooms = UserDmroom.find_by(user_id: @user.id, dmroom_id: rooms)
         unless user_dmrooms.nil?
          @room = user_dmrooms.room
         else
          @room = Room.new
          @room.save
          UserDmroom.create(user_id: current_user.id, room_id: @room.id)
          UserDmroom.create(user_id: @user.id, room_id: @room.id)
         end
        @dms = room.dms
        @dm = Dm.new(room_id: @room.id)
    end

    private

    def dm_params
        params.require(:dm).permit(:dm, :dmroom_id)
    end
    def reject_non_related
        user = User.find(params[:id])
        unless current_user.following?(user) && user.following?(current_user)
          redirect_to posts_path
        end
    end

end
