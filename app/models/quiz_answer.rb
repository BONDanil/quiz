class QuizAnswer < ApplicationRecord
  belongs_to :user
  belongs_to :quiz_session
  belongs_to :question

  validates :question, uniqueness: { scope: [:quiz_session, :user] }
end
