class CreateMenuItems < ActiveRecord::Migration[8.0]
  def change
    create_table :menu_items do |t|
      t.belongs_to :menu, null: false, foreign_key: true
      t.text :description
      t.boolean :lact_free
      t.boolean :gluten_free
      t.string :name

      t.timestamps
    end
  end
end
