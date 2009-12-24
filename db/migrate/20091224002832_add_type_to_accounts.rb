class AddTypeToAccounts < ActiveRecord::Migration
  def self.up
    add_column :accounts, :type, :string
    add_index :accounts, :type
    
    Account.roots.each { |r| r.subtree.each { |a| a.update_attribute(:type, r.name.singularize) } } 
  end

  def self.down
    remove_index :accounts, :type
    remove_column :accounts, :type
  end
end
