class CreateShares < ActiveRecord::Migration[5.2]
  def change
    create_table :shares do |t|
      t.integer :sender_id
      t.integer :receiver_id
      t.integer :shareable_id
      t.string :shareable_type

      t.timestamps
    end
  end
end
