class CreateSessions < ActiveRecord::Migration[6.1]
  def change
    create_table :sessions do |t|
      t.references :game, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.datetime :started_at
      t.datetime :ended_at
      t.string :clicks, array: true, default: []
      t.boolean :ready?, default: false
      t.string :session_id, null: false
      t.text :data

      t.timestamps
    end
    add_index :sessions, :session_id, unique: true
    add_index :sessions, :updated_at
  end
end
