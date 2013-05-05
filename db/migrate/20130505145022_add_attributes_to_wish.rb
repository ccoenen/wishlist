class AddAttributesToWish < ActiveRecord::Migration
  def change
    add_column :wishes, :position, :integer
    add_column :wishes, :public, :boolean
    add_column :wishes, :received_on, :datetime
  end
end
