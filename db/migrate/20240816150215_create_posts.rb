class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|
      t.integer :user_id
      t.string :title
      t.string :caption
      t.integer :tag_id
      t.datetime :post_time
      t.boolean :publication_range
      t.boolean :status
      t.timestamps
    end
  end
end
