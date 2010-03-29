class AddMappingIdToImports < ActiveRecord::Migration
  def self.up
    add_column :imports, :mapping_id, :integer
  end

  def self.down
    remove_column :imports, :mapping_id
  end
end
