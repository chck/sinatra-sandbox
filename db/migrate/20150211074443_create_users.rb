class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users, id: false do |t|
      t.column :id, 'BIGINT(20) PRIMARY KEY'
      t.text :screen_name, null: false, unique: true
      t.text :description
      t.timestamps
    end
  end
end
