class Player::QuizSessionsController < ApplicationController
  before_action :validate_quiz_session!
  before_action :validate_player!

  def show
    result = QuizSessions::Synchronous::ProcessPlayers.call(
      quiz_session: @quiz_session,
      current_user: current_user
    )

    if result.failure?
      redirect_to root_path, notice: result.errors
    else
      render_proper_page
    end
  end

  def answer
    binding.pry
  end

  private

  def render_proper_page
    if quiz_session.pending?
      render 'player/quiz_sessions/pending_session'
    elsif quiz_session.in_progress?
      render 'player/quiz_sessions/in_progress_session'
    elsif quiz_session.finished?
      render 'player/quiz_sessions/session_rating'
    end
  end

  def quiz_session
    @quiz_session ||= QuizSession.find(params[:id])
  end

  def validate_quiz_session!
    if quiz_session.default?
      redirect_to root_path, notice: 'For requested quiz url was forbidden'
    else if quiz_session.user == current_user
           redirect_to quiz_session, notice: 'You are the host of this quiz!'
         end
    end
  end

  def validate_player!
    if quiz_session.sessions_players.where(user: current_user, active: false).any?
      redirect_to root_path, notice: 'You were excluded from that quiz.'
    end
  end
end
