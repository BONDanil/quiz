class RemoveQuizSessionIdFromQuestions < ActiveRecord::Migration[7.0]
  def change
    remove_column :questions, :quiz_session_id
  end
end
