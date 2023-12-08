class CreateQuizAnswers < ActiveRecord::Migration[7.0]
  def change
    create_table :quiz_answers do |t|
      t.references :quiz_session, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :points

      t.timestamps
    end
  end
end
