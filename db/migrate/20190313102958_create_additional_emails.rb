class CreateAdditionalEmails < ActiveRecord::Migration[5.2]
  def change
    create_table :additional_emails do |t|
      t.references :user, foreign_key: true
      t.string :email

      t.timestamps
    end
  end
end
