class CreateGameSessions < ActiveRecord::Migration[6.1]
  def change
    create_table :sessions do |t|
      t.references :game, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.datetime :started_at
      t.datetime :ended_at
      t.string :clicks, array: true, default: []
      t.boolean :ready?, default: false
      t.timestamps
    end
  end
end
