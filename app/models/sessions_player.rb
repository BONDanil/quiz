class SessionsPlayer < ApplicationRecord
  belongs_to :user
  belongs_to :quiz_session

  def points
    quiz_session.quiz_answers.where(user: user, correct: true).count
  end
end
