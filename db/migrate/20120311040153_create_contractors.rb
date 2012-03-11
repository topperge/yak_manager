class CreateContractors < ActiveRecord::Migration
  def change
    create_table :contractors do |t|
      t.string :clid
      t.string :email
      t.boolean :deleted
      t.integer :company_id

      t.timestamps
    end
  end
end
