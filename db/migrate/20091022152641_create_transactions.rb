class CreateTransactions < ActiveRecord::Migration
  def self.up
    create_table :transactions do |t|
      t.integer :sender_id
      t.integer :recipient_id
      t.date :issued_on
      t.decimal :total_amount, :precision => 20, :scale => 4
      t.decimal :tax_amount, :precision => 20, :scale => 4
      t.string :currency, :null => false, :limit => 3
      t.string :description
      t.string :identifier
      t.integer :account_id
      t.integer :match_id
      t.timestamps
    end
    
    add_index :transactions, :sender_id
    add_index :transactions, :recipient_id
    add_index :transactions, :issued_on
    add_index :transactions, :total_amount
    add_index :transactions, :identifier
    add_index :transactions, :account_id
  end

  def self.down
    drop_table :transactions
  end
end
