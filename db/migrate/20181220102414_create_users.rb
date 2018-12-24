class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :alias
      t.date :birth_date
      t.string :last_name
      t.string :first_name
      t.boolean :open
      t.string :user_name
      t.string :work
      t.string :subscription_code

      t.timestamps
    end
  end
end
