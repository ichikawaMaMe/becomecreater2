class TagController < ApplicationController
  def show
    @tag = Tag.find(params[:id])
  end

end
