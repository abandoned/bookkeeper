class DefaultLedgerItemsTransactedOnToToday < ActiveRecord::Migration
  def self.up
    change_column :ledger_items, :transacted_on, :date, :default => Time.now
  end

  def self.down
    change_column :ledger_items, :transacted_on, :date
  end
end
