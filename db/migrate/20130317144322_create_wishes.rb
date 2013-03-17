class CreateWishes < ActiveRecord::Migration
  def change
    create_table :wishes do |t|
      t.string :title
      t.string :taken_by
      t.text :notes
      t.string :secret
      t.string :url

      t.timestamps
    end
  end
end
