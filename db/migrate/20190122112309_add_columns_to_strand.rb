class AddColumnsToStrand < ActiveRecord::Migration[5.2]
  def change
    add_column :strands, :title, :string
    add_column :strands, :notes, :text
    # add_column :strands, :address, :text
    add_column :strands, :all_day, :boolean, default: false
    add_column :strands, :repeat_daily, :boolean, default: false
    add_column :strands, :repeat_weekly, :boolean, default: false
    add_column :strands, :repeat_monthly, :boolean, default: false
    add_column :strands, :repeat_yearly, :boolean, default: false
    add_column :strands, :latitude, :string
    add_column :strands, :longitude, :string
    add_column :strands, :remind_me_on, :datetime
    rename_column :strands, :location, :address

  end
end
