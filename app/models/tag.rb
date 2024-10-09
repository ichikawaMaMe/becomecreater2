class Tag < ApplicationRecord
    has_many :tag_tables, dependent: :destroy
    has_many :posts, through: :tag_tables

    def self.serch_for(content, method)
        if method == 'perfect'
            Tag.where(name: content)
        else
            Tag.where('name LIKE ?', '%' + content + '%')
        end
    end

    validates :name, presence: true, uniqueness: true
end
