class CreateDmrooms < ActiveRecord::Migration[6.1]
  def change
    create_table :dmrooms do |t|
      t.integer :user_id
      t.datetime :made_time
      t.datetime :update_time
      t.timestamps
    end
  end
end
