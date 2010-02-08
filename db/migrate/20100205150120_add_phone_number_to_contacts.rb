class AddPhoneNumberToContacts < ActiveRecord::Migration
  def self.up
    add_column :contacts, :phone_number, :string
  end

  def self.down
    remove_column :contacts, :phone_number
  end
end
