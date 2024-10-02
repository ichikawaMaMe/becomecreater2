class Tag < ApplicationRecord
    has_many :tag_tables, dependent: :destroy
    
    def self.serch_for(content, method)
        if method == 'perfect'
            Tag.where(name: content)
        else
            Tag.where('name LIKE ?', '%' + content + '%')
        end 
    end 
    
end
