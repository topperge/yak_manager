class CreateContractorFiles < ActiveRecord::Migration
  def change
    create_table :contractor_files do |t|
      t.integer :user_id
      t.integer :company_id
      t.string :status
      t.integer :users_created
      t.integer :users_updated
      t.integer :users_deleted
      t.integer :users_errored

      t.timestamps
    end
  end
end
