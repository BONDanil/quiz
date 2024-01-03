class QuizSessions::PlayersController < ApplicationController
  before_action :find_quiz_session!

  def index
    @players = @quiz_session.sessions_players
  end

  private

  def find_quiz_session!
    @quiz_session = QuizSession.find(params[:quiz_session_id])
  end
end
