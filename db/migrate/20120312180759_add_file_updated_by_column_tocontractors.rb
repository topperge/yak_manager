class AddFileUpdatedByColumnTocontractors < ActiveRecord::Migration
  def up
    add_column :contractors, :contractor_file_id, :integer
  end

  def down
    remove_column :contractors, :contractor_file_id
  end
end
