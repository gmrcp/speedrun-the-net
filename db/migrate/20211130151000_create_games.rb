class CreateGames < ActiveRecord::Migration[6.1]
  def change
    create_table :games do |t|
      t.references :lobby, null: false, foreign_key: true
      t.string :category, default: 'default'
      t.string :start_url
      t.string :end_url
      t.boolean :running?, default: false
      t.string :winner

      t.timestamps
    end
  end
end
