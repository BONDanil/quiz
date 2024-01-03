class QuizSessions::QuestionsController < ApplicationController
  before_action :find_quiz_session!

  def index
    @questions = @quiz_session.questions
  end

  private

  def find_quiz_session!
    @quiz_session = QuizSession.find(params[:quiz_session_id])
  end
end
