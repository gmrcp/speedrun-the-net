class CreateGameSessions < ActiveRecord::Migration[6.1]
  def change
    create_table :game_sessions do |t|
      t.references :game, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.datetime :started_at
      t.datetime :ended_at
      t.integer :clicks, default: 0
      t.integer :score, default: 0
      t.string :path, array: true, default: []
      t.boolean :ready, default: false
      t.column :status, :integer, default: 0
      t.integer :avatar, null: false, default: 1
      t.timestamps
    end
  end
end
