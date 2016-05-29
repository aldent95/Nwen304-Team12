class AddPasswordDigestToUsers < ActiveRecord::Migration
  def change
    add_column :m_users, :password_digest, :string
  end
end
