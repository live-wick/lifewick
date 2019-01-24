class AddWickNameIntoStrand < ActiveRecord::Migration[5.2]
  def change
    add_column :strands, :wick_name, :string
    Strand.all.each{|st| st.update(wick_name: st.wick.name)}
  end


end
