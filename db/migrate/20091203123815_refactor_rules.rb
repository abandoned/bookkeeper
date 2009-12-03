class RefactorRules < ActiveRecord::Migration
  def self.up
    rename_column :rules, :regexp, :matched_description
    rename_column :rules, :debit, :matched_debit
    rename_column :rules, :sender_id, :new_sender_id
    rename_column :rules, :recipient_id, :new_recipient_id
    rename_column :rules, :matching_account_id, :new_account_id
    add_column :rules, :matched_sender_id, :integer
    add_column :rules, :matched_recipient_id, :integer
  end

  def self.down
    remove_column :rules, :matched_recipient_id
    remove_column :rules, :matched_sender_id
    rename_column :rules, :new_account_id, :matching_account_id
    rename_column :rules, :new_recipient_id, :recipient_id
    rename_column :rules, :new_sender_id, :sender_id
    rename_column :rules, :matched_debit, :debit
    rename_column :rules, :matched_description, :regexp
  end
end
