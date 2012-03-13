class AddUsersColumnsToContractorFiles < ActiveRecord::Migration
  def up
    add_column :contractor_files, :users_found, :integer
    add_column :contractor_files, :users_not_changed, :integer
  end

  def down
    remove_column :contractor_files, :users_found, :users_not_changed
  end
end
