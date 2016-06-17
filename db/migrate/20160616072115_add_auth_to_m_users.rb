class AddAuthToMUsers < ActiveRecord::Migration
  def change
    add_column :m_users, :auth_digest, :string
    add_column :m_users, :auth_sent_at, :datetime
  end
end
