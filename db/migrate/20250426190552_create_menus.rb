class CreateMenus < ActiveRecord::Migration[8.0]
  def change
    create_table :menus do |t|
      t.integer :availability
      t.string :name
      t.text :description
      t.string :signed_chef
      t.integer :day_period

      t.timestamps
    end
  end
end
