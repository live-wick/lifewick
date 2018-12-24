class CreateHandshakes < ActiveRecord::Migration[5.2]
  def change
    create_table :handshakes do |t|
      t.string :dtype
      t.boolean :notified
      t.date :result_date
      t.integer :status
      t.integer :sender_id
      t.integer :receiver_id

      t.timestamps
    end
  end
end
