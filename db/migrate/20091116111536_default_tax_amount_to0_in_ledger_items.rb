class DefaultTaxAmountTo0InLedgerItems < ActiveRecord::Migration
  def self.up
    change_column :ledger_items, :tax_amount, :decimal, :precision => 20, :scale => 4, :default => 0
  end

  def self.down
    change_column :ledger_items, :tax_amount, :precision => 20, :scale => 4
  end
end
