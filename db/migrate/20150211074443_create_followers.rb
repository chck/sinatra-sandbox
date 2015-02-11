class CreateFollowers < ActiveRecord::Migration
  def change
    create_table :followers do |t|
      t.text :screen_name, unique: true, null: false
      t.text :description
      t.timestamps
    end
  end
end
