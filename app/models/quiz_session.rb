class QuizSession < ApplicationRecord
  belongs_to :user
  has_many :sessions_questions, class_name: 'SessionsQuestion', dependent: :destroy
  has_many :questions, through: :sessions_questions
end
