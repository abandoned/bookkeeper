class CreateRules < ActiveRecord::Migration
  def self.up
    create_table :rules do |t|
      t.integer :sender_id
      t.integer :recipient_id
      t.integer :account_id
      t.integer :matching_account_id
      t.string :description_matcher
      t.boolean :debit
      t.timestamps
    end
  end

  def self.down
    drop_table :rules
  end
end