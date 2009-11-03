class CreateMappings < ActiveRecord::Migration
  def self.up
    create_table :mappings do |t|
      t.string :name
      t.string :currency, :limit => 3
      t.integer :date_row
      t.integer :total_amount_row
      t.integer :tax_amount_row
      t.integer :description_row
      t.integer :second_description_row
      t.integer :identifier_row
      t.boolean :has_title_row
      t.boolean :day_follows_month
      t.boolean :reverses_sign
      
      t.timestamps
    end
  end

  def self.down
    drop_table :mappings
  end
end