class CreateWatches < ActiveRecord::Migration
  def self.up
    create_table :watches do |t|
      t.string :name
      t.string :url
      t.integer :last_response_time, :default => 0
      t.integer :warning_time
      t.boolean :active, :default => true
      t.string :content_match
      t.integer :status_id, :default => Status::UP
      t.integer :site_id
      t.datetime :last_status_change_at
      
      t.timestamps
    end
  end

  def self.down
    drop_table :watches
  end
end
