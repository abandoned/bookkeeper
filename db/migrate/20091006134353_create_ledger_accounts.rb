class CreateLedgerAccounts < ActiveRecord::Migration
  def self.up
    create_table :ledger_accounts do |t|
      t.integer :parent_id
      t.string :name
      
      t.timestamps
    end
  end
  
  def self.down
    drop_table :ledger_accounts
  end
end
