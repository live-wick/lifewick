class CreateAttachments < ActiveRecord::Migration[5.2]
  def change
    create_table :attachments do |t|
      t.text :description
      t.references :strand, foreign_key: true

      t.timestamps
    end
  end
end
