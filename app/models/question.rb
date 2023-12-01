class Question < ApplicationRecord
  belongs_to :user
  belongs_to :category
  belongs_to :quiz_session, optional: true
  has_one_attached :image
end
