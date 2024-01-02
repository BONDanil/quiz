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

  def current_question
    questions[current_question_index]
  end

  def current_answers
    quiz_answers.where(question: current_question).order(:created_at)
  end

  def active_player_ids
    sessions_players.where(active: true).pluck(:user_id)
  end

  def host
    @host ||= user
  end

  scope :related_to_user, ->(user) {
    includes(:sessions_players)
      .where(user_id: user.id)
      .or(QuizSession.where(sessions_players: { user_id: user.id }))
  }
end
