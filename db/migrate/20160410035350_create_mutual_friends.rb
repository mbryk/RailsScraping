class CreateMutualFriends < ActiveRecord::Migration
  def change
    create_table :mutual_friends do |t|
      t.integer :u1_id
      t.integer :u2_id
      t.integer :count

      t.timestamps
    end
  end
end
