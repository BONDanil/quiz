class QuizSessionsController < ApplicationController
  def index
    @quiz_sessions = QuizSession.related_to_user(current_user)
  end
end
