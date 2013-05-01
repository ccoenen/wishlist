class AddImageToWish < ActiveRecord::Migration
  def change
    add_column :wishes, :image, :string
  end
end
