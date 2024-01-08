class Question < ApplicationRecord
  belongs_to :user
  belongs_to :category
  has_many :sessions_questions, class_name: 'SessionsQuestion', dependent: :destroy
  has_many :quiz_sessions, through: :sessions_questions
  has_one_attached :image

  def not_used?
    quiz_sessions.blank?
  end

  scope :not_used, -> {
    left_joins(:quiz_sessions)
      .group('questions.id')
      .having('COUNT(quiz_sessions.id) = 0')
  }

  scope :general, -> {
    where(user_id: nil)
  }

  def session_answers(quiz_session)
    quiz_session.quiz_answers.where(question: self)
  end
end
