class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users, id: false, primary_key: 'id' do |t|
      t.integer :id, null: false, unique: true, limit: 20
      t.text :screen_name, null: false, unique: true
      t.text :description
      t.timestamps
    end
  end
end
