class AddFileUpdatedByColumnTocontractors < ActiveRecord::Migration
  def up
    add_column :contractors, :last_updated_file_id, :integer
  end

  def down
    remove_column :contractors, :last_updated_file_id
  end
end
