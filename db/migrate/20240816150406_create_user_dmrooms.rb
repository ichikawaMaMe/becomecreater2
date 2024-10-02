class CreateUserDmrooms < ActiveRecord::Migration[6.1]
  def change
    create_table :user_dmrooms do |t|
      t.integer :user_id
      t.integer :dmroom_id
      t.timestamps
    end
  end
end
