class RemoveDefaultFromAnswers < ActiveRecord::Migration[7.0]
  def change
    change_column :quiz_answers, :correct, :boolean
  end
end
