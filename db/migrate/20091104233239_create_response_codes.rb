class CreateResponseCodes < ActiveRecord::Migration
  def self.up
    create_table :response_codes do |t|
      t.integer :code
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :response_codes
  end
end
