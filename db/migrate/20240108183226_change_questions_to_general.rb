class ChangeQuestionsToGeneral < ActiveRecord::Migration[7.0]
  def change
    change_column :questions, :user_id, :integer, null: true
  end
end
