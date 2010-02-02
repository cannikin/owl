class CreateWatches < ActiveRecord::Migration
  def self.up
    create_table :watches do |t|
      t.string :name
      t.string :url
      t.integer :last_response_time, :default => 0
      t.integer :warning_time
      t.boolean :active, :default => true
      t.string :content_match
      t.integer :expected_response, :default => 200
      t.integer :status_id, :default => Status::UP
      t.integer :site_id
      t.datetime :last_status_change_at
      t.string :status_reason
      
      t.timestamps
    end
    
    add_index :watches, :id, :unique => true
    add_index :watches, :site_id

  end

  def self.down
    drop_table :watches
  end
end
