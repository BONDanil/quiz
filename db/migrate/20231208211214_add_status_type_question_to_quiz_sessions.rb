class AddStatusTypeQuestionToQuizSessions < ActiveRecord::Migration[7.0]
  def change
    add_column :quiz_sessions, :status, :string, default: 'pending'
    add_column :quiz_sessions, :session_type, :string, default: 'default'
    add_column :quiz_sessions, :current_question_index, :integer, default: 0
  end
end
