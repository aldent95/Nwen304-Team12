class AddPaymentTypeToListings < ActiveRecord::Migration
  def change
    add_column :listings, :payment_type, :string
  end
end
