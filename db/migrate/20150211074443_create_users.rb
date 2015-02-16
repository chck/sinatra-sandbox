class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.text :screen_name, null: false, unique: true
      t.text :description
      t.timestamps
    end
  end
end
