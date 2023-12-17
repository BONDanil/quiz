class ChangeQuizAnswers < ActiveRecord::Migration[7.0]
  def change
    remove_column :quiz_answers, :points, :integer
    add_reference :quiz_answers, :question, foreign_key: true
    add_column :quiz_answers, :text, :string
    add_column :quiz_answers, :correct, :boolean, default: false
    add_index :quiz_answers, [:quiz_session_id, :question_id, :user_id], unique: true, name: 'quiz_answers_unique_index'
  end
end
