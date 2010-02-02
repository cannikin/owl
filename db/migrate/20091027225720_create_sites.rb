class CreateSites < ActiveRecord::Migration
  def self.up
    create_table :sites do |t|
      t.string :name

      t.timestamps
    end
    
    add_index :sites, :id, :unique => true
    
  end

  def self.down
    drop_table :sites
  end
end
