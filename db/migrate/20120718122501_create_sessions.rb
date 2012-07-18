class CreateSessions < ActiveRecord::Migration
  def change
    create_table :sessions do |t|
      t.references :user
      t.string :sid
      t.string :unique

      t.timestamps
    end
    add_index :sessions, :user_id
  end
end
