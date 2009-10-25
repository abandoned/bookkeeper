class CreateFileImportFormats < ActiveRecord::Migration
  def self.up
    create_table :file_import_formats do |t|
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
      
      t.timestamps
    end
  end

  def self.down
    drop_table :file_import_formats
  end
end