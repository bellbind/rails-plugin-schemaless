class <%= migration_name %> < ActiveRecord::Migration
  def self.up
    create_table :<%= table_name %> do |t|
      t.timestamps
    end
    create_table :<%= singular_name %>_cells do |t|
      t.integer :<%= singular_name %>_id
      t.string :name
      t.string :value
      t.timestamps
    end
  end
  def self.down
    drop_table :<%= table_name %>
    drop_table :<%= singular_name %>_cells
  end
end
