class DmroomsController < ApplicationController
    def create
        @dmroom = Dmroom.create
        @current_user_dmroom = @dmroom.user_dmrooms.create(user_id: current_user.id)
        @another_user_dmroom = @dmroom.user_dmrooms.create(user_id: params[:user_dmroom][:user_id])
        redirect_to room_path(@dmroom)
    end 
    
    def index
        my_room_id = current_user.user_dmrooms.pluck(:dmroom_id)
        @another_user_dmrooms = User_dmroom
                                .where(dmroom_id: my_room_id)
                                .where.not(user_id: current_user.id)
                                .preload(dmroom: :dms).preload(user: { icon_attachment: :blob}) #なにこれ
    end 
    
    def show
        @dmroom = Dmroom.find(parms[:id])
        if @dmroom.user_dmroom.where(user_id: current_user.id).present?
            @dms = @dmroom.dms.all
            @dm = Dm.new
            @user_dmroom = @dmroom.user_dmroom
            @another_user_dmroom = @user_dmrooms.where.not(user_id: current_user.id).first
        else
            redirect_back(fallback_location: root_path)
        end 
    end 
end

