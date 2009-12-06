class RenameIsSelfToSelfInContacts < ActiveRecord::Migration
  def self.up
    rename_column :contacts, :is_self, :self
  end

  def self.down
    rename_column :contacts, :self, :is_self
  end
end
