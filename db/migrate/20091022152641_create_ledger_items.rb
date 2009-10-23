class CreateLedgerItems < ActiveRecord::Migration
  def self.up
    create_table :ledger_items do |t|
      t.integer :sender_id
      t.integer :recipient_id
      t.date :issued_on
      t.decimal :total_amount, :precision => 20, :scale => 4
      t.decimal :tax_amount, :precision => 20, :scale => 4
      t.string :currency, :null => false, :limit => 3
      t.string :description
      t.string :identifier
      t.integer :ledger_account_id
      t.integer :ledger_item_group_id
      t.timestamps
    end
    
    add_index :ledger_items, :sender_id
    add_index :ledger_items, :recipient_id
    add_index :ledger_items, :issued_on
    add_index :ledger_items, :total_amount
    add_index :ledger_items, :identifier
    add_index :ledger_items, :ledger_account_id
  end

  def self.down
    drop_table :ledger_items
  end
end
