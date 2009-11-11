class CreateAccounts < ActiveRecord::Migration
  def self.up
    create_table :accounts do |t|
      t.string :ancestry
      t.string :name
      
      t.timestamps
    end    
    add_index :accounts, :ancestry
  end
  
  def self.down
    drop_table :accounts
    remove_index :accounts, :ancestry
  end
end
