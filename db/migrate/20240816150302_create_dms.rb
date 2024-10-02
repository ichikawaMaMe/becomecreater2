class CreateDms < ActiveRecord::Migration[6.1]
  def change
    create_table :dms do |t|
      t.integer :user_id
      t.integer :dmroom_id
      t.datetime :send_time
      t.text :conversation
      t.datetime :update_time
      t.timestamps
    end
  end
end
