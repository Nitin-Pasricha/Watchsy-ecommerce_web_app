class CreateLineItems < ActiveRecord::Migration[6.1]
  def change
    create_table :line_items do |t|
      t.references :store, null: false, foreign_key: true
      t.belongs_to :user, null: false, foreign_key: true
      t.integer :qty

      t.timestamps
    end
  end
end
