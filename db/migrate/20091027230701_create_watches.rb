class CreateWatches < ActiveRecord::Migration
  def self.up
    create_table :watches do |t|
      t.string :name
      t.string :url
      t.integer :status_id
      t.integer :site_id
      
      t.timestamps
    end
  end

  def self.down
    drop_table :watches
  end
end
