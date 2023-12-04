class CreateSessionsQuestions < ActiveRecord::Migration[7.0]
  def change
    create_table :sessions_questions do |t|
      t.references :question, null: false, foreign_key: true
      t.references :quiz_session, null: false, foreign_key: true

      t.timestamps
    end
  end
end
