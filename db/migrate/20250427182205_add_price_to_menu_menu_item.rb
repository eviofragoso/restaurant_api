class AddPriceToMenuMenuItem < ActiveRecord::Migration[8.0]
  def change
    change_table :menu_menu_items do |t|
      t.decimal :price
    end
  end
end
