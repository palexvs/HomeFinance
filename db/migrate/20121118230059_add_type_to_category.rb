class AddTypeToCategory < ActiveRecord::Migration
  def change
    add_column :categories, :type_id, :integer, :null => false
  end
end
