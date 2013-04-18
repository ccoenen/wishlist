class RenameTakenByColumn < ActiveRecord::Migration
  def change
    rename_column :wishes, :taken_by, :claimed_by
  end
end
