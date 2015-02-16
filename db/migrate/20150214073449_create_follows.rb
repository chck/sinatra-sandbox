class CreateFollows < ActiveRecord::Migration
  def change
    create_table :follows, id: false do |t|
      t.integer :follower_id, null: false, limit: 20
      t.integer :followee_id, null: false, limit: 20
      t.timestamps
    end
  end
end
