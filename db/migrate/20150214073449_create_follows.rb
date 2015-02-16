class CreateFollows < ActiveRecord::Migration
  def change
    create_table :follows do |t|
      t.integer :user_id, null: false, unique: true
      t.integer :followee, null: false, unique: true
      t.timestamps
    end
  end
end
