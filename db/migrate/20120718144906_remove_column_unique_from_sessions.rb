class RemoveColumnUniqueFromSessions < ActiveRecord::Migration
  def change
    remove_column :sessions, :unique
    add_index :sessions, :sid, unique: true
  end
end
