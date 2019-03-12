class AddEventIdIntoStrand < ActiveRecord::Migration[5.2]
  def change
    add_column :strands, :is_event, :boolean, default: false
  end
end
