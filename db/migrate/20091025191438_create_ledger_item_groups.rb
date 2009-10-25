class CreateLedgerItemGroups < ActiveRecord::Migration
  def self.up
    create_table :ledger_item_groups do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :ledger_item_groups
  end
end
