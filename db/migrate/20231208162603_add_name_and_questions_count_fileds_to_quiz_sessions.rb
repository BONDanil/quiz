class AddNameAndQuestionsCountFiledsToQuizSessions < ActiveRecord::Migration[7.0]
  def change
    add_column :quiz_sessions, :name, :string
    add_column :quiz_sessions, :questions_count, :integer
  end
end
