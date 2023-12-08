class QuizSession < ApplicationRecord
  belongs_to :user
  has_many :sessions_questions, class_name: 'SessionsQuestion', dependent: :destroy
  has_many :questions, through: :sessions_questions
  has_many :sessions_players, class_name: 'SessionsPlayer', dependent: :destroy
  has_many :players, through: :sessions_players, source: :user
  has_many :quiz_answers

  enum status: {
    pending: 'pending',
    in_progress: 'in_progress',
    finished: 'finished'
  }

  enum session_type: {
    default: 'default',
    synchronous: 'synchronous'
  }
end
