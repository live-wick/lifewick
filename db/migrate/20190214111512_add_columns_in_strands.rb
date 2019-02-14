class AddColumnsInStrands < ActiveRecord::Migration[5.2]
  def change
    add_column :strands, :is_public, :boolean, default: true
    add_column :strands, :is_private, :boolean, default: false
  end
end
