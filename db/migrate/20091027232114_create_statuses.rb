class CreateStatuses < ActiveRecord::Migration
  def self.up
    create_table :statuses do |t|
      t.string :name
      t.string :css   # CSS class name
    end
  end

  def self.down
    drop_table :statuses
  end
end
