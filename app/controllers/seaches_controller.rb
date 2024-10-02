class SeachesController < ApplicationController
    def search
        @model = params[:model]
        @content = params[:content]
        @method = params[:method]
        
        if @model == "user"
            @records = User.search_for(@content, @method)
        elsif
            @records = Posts.serach_for(@content, @method)
        else
            @records = Tags.serach_for(@content, @method)
        end 
    end 
end
