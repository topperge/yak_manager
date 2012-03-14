class AddRecordIdToContractorFileRecords < ActiveRecord::Migration
  def up
    add_column :contractor_file_records, :record_id, :integer
  end

  def down
    remove_column :contractor_file_records, :record_id
  end
end
