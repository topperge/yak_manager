class ChangeMessageToTextContractorFileRecords < ActiveRecord::Migration
  def up
    change_column :contractor_file_records, :message, :text
  end

  def down
    change_column :contractor_file_records, :message, :string
  end
end
