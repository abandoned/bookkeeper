class AddIndexOnDescriptionToLedgerItems < ActiveRecord::Migration
  def self.up
    add_index :ledger_items, :description
    remove_index :ledger_items, :identifier
  end

  def self.down
    remove_index :ledger_items, :description
    add_index :ledger_items, :identifier
  end
end
