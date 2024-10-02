class Post < ApplicationRecord
    has_one_attached :image
    belongs_to :user
    has_many :access
    has_many :bookmarks
    has_many :tags,through: :tag_tables
    has_many :tag_tables, dependent: :destroy
    has_many :post_comments, dependent: :destroy

    #タグ付け用メソッド
    def save_tags(tags)
        tags.each do |new_tags|
            self.tags.find_or_create_by(name: new_tags)
        end
    end
    def  update_tags(latest_tags)
        if self.tags.empty?
            latest_tags.each do |latest_tag|
                self.tags.find_or_create_by(name: latest_tag)
            end
        elsif latest_tags.empty?
            self.tags.each do |tag|
                self.tags.delete(tag)
            end
        else
            current_tags = self.tags.pluck(:name)
            old_tags = current_tags - latest_tags
            new_tags = latest_tags - current_tags
              old_tags.each do |old_tag|
                tag = self.tags.find_by(name: old_tag)
                self.tags.delete(tag) if tag.present?
              end
              new_tags.each do |new_tag|
                 self.tags.find_or_create_by(name: new_tag)
              end
        end
    end

    def self.search_for(content, method)
        if method == 'perfect'
            Post.where(title: content)
        else
            Post.where('name LIKE ?', '%' + contetnt + '%')
        end
    end

end
