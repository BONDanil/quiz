class AddQuizSessionReferencesToQuestions < ActiveRecord::Migration[7.0]
  def change
    add_reference :questions, :quiz_session, null: true, foreign_key: true
  end
end
