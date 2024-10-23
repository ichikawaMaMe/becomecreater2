class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|
      t.integer :user_id
      t.string :title
      t.string :caption
#      t.integer :tag, null: false, foreign_key: true
      t.datetime :post_time
      t.boolean :publication_range
      t.boolean :status
      t.string :visibility
      t.text :description
      t.timestamps
    end
  end
end
