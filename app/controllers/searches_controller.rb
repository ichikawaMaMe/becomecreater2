class SearchesController < ApplicationController
  def search
    @model = params[:model]
    @content = params[:content]
    @method = params[:method]

    # 検索処理の分岐
    if @model == 'user'
      @records = User.search_for(@content, @method)
    elsif @model == 'post'
      @records = Post.search_for(@content, @method)
    elsif @model == 'tag'
      @records = Tag.search_for(@content, @method)
    else
      @records = []
    end
  end
end