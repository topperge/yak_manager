class CreateContractorFileRecords < ActiveRecord::Migration
  def change
    create_table :contractor_file_records do |t|
      t.string :clid
      t.string :email
      t.string :flag
      t.string :message
      t.integer :contractor_file_id
      t.integer :company_id

      t.timestamps
    end
  end
end
