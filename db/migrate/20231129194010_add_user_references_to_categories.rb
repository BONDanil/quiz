class AddUserReferencesToCategories < ActiveRecord::Migration[7.0]
  def change
    add_reference :categories, :user, foreign_key: true
  end
end
