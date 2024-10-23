class DmsController < ApplicationController
  def show
    @user = User.find(params[:id])
    rooms = current_user.user_dmrooms.pluck(:dmroom_id) # 自身が参加している部屋IDを取得
    user_dmroom = UserDmroom.find_by(user_id: @user.id, dmroom_id: rooms) # 他ユーザーが参加しているDMルームを検索

    if user_dmroom
      @room = user_dmroom.dmroom
    else
      @room = Dmroom.create # 新しいDMルームを作成
      UserDmroom.create(user_id: current_user.id, dmroom_id: @room.id)
      UserDmroom.create(user_id: @user.id, dmroom_id: @room.id)
    end

    @dms = @room.dms
    @dm = Dm.new(dmroom_id: @room.id)

    if params[:content].present?
      @search_results = User.search_for(params[:content], params[:method])
    end

  end
    def index
    # フォローしているユーザーのIDを取得
    following_user_ids = current_user.following_ids
    # DMルームを取得
    dmroom_user_ids = Dmroom.where(user_id: following_user_ids).pluck(:user_id)

    # フォローしているユーザーまたはDMルームに参加しているユーザーを取得
    @dm_users = User.where(id: following_user_ids).or(User.where(id: dmroom_user_ids))

    # DMメッセージを取得
    @dmroom = Dmroom.find_by(user_id: current_user.id)
    @dms = Dm.where(dmroom_id: @dmroom&.id).order(created_at: :asc) # DMルームIDを使用してメッセージを取得
    @dm = Dm.new
    end

  def create
    @dm = Dm.new(dm_params)
    if @dm.save
      respond_to do |format|
        format.js
      end
    else
      render :new
    end
  end
  def remove_dm
  @user = User.find(params[:id])
  respond_to do |format|
    format.js
  end
  end
  private

  def dm_params
    params.require(:dm).permit(:conversation, :dmroom_id).merge(user_id: current_user.id)
  end
end
