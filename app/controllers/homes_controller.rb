class HomesController < ApplicationController
    def top
    end 
    def about
    end 
    
    def index
        @posts = Post.all
    end 
end
