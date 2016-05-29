class CreateListings < ActiveRecord::Migration
  def change
    create_table :listings do |t|
      t.integer :user_id
      t.string :title
      t.text :description
      t.string :category
      t.string :imageurl
      t.integer :purchaser_id
      t.decimal :price

      t.timestamps null: false
    end
  end
end
