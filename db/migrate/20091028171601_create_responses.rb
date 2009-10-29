class CreateResponses < ActiveRecord::Migration
  def self.up
    create_table :responses do |t|
      t.integer :time
      t.integer :status
      t.string :reason
      t.integer :watch_id
      
      t.timestamps
    end
  end

  def self.down
    drop_table :responses
  end
end
