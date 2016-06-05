class RemovePasswordFromMUsers < ActiveRecord::Migration
  def change
    remove_column :m_users, :password, :string
  end
end
