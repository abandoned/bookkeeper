class AddEndingBalanceToImports < ActiveRecord::Migration
  def self.up
    add_column :imports, :ending_balance, :decimal, :precision => 20, :scale => 4
  end

  def self.down
    remove_column :imports, :ending_balance
  end
end
