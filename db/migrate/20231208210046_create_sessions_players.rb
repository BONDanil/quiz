class CreateSessionsPlayers < ActiveRecord::Migration[7.0]
  def change
    create_table :sessions_players do |t|
      t.references :quiz_session, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.boolean :active

      t.timestamps
    end
  end
end
