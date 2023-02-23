class CreateStores < ActiveRecord::Migration[6.1]
  def change
    create_table :stores do |t|
      t.integer :product_id
      t.string :name
      t.string :category
      t.text :description
      t.string :gender
      t.string :colour
      t.float :price

      t.timestamps
    end
  end
end
