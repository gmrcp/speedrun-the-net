class CreateLobbies < ActiveRecord::Migration[6.1]
  def change
    create_table :lobbies do |t|
      t.string :code
      t.references :owner, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
