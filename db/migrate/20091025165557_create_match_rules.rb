class CreateMatchRules < ActiveRecord::Migration
  def self.up
    create_table :match_rules do |t|
      t.integer :sender_id
      t.integer :recipient_id
      t.integer :ledger_account_id
      t.integer :matching_ledger_account_id
      t.string :description_matcher
      t.boolean :debit
      t.timestamps
    end
  end

  def self.down
    drop_table :match_rules
  end
end