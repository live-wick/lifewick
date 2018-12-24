class CreateStrands < ActiveRecord::Migration[5.2]
  def change
    create_table :strands do |t|
      t.datetime :end_date
      t.datetime :start_date
      t.string :location
      t.text :description
      t.references :user, foreign_key: true
      t.references :wick, foreign_key: true
      t.integer :source

      t.timestamps
    end
  end
end
