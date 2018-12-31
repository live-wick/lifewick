class CreateShares < ActiveRecord::Migration[5.2]
  def change
    create_table :shares do |t|
      t.integer :sender_id
      t.integer :receiver_id
      t.references :shareable, polymorphic: true, index: true
      t.timestamps
    end
  end
end
