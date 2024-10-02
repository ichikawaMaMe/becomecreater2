class CreateDmrooms < ActiveRecord::Migration[6.1]
  def change
    create_table :dmrooms do |t|
      t.datetime :made_time
      t.datetime :update_time
      t.timestamps
    end
  end
end
