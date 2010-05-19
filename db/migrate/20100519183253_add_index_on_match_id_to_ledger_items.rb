class AddIndexOnMatchIdToLedgerItems < ActiveRecord::Migration
  def self.up
    add_index :ledger_items, :match_id
  end

  def self.down
    remove_index :ledger_items, :match_id
  end
end
