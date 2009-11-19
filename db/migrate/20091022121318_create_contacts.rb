class CreateContacts < ActiveRecord::Migration
  def self.up
    create_table :contacts do |t|
      t.boolean :is_self, :default => false
      t.string :name
      t.string :contact_name
      t.text :address
      t.string :city
      t.string :state
      t.string :postal_code
      t.string :country
      t.string :country_code, :limit => 2
      t.string :tax_number
      t.timestamps
    end
  end
  
  def self.down
    drop_table :contacts
  end
end
