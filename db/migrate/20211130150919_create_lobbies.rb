class CreateLobbies < ActiveRecord::Migration[6.1]
  def change
    create_table :lobbies do |t|
      t.string :code
      t.string :category
      t.string :start_url
      t.string :end_url
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
