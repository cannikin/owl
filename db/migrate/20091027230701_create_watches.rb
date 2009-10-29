class CreateWatches < ActiveRecord::Migration
  def self.up
    create_table :watches do |t|
      t.string :name
      t.string :url
      t.integer :last_response_time
      t.integer :warning_time
      t.boolean :active, :default => true
      t.string :content
      t.integer :status_id, :default => Status::DISABLED
      t.integer :site_id
      
      t.timestamps
    end
  end

  def self.down
    drop_table :watches
  end
end
