class QuizSessionsController < ApplicationController
  def new
    @quiz_session = QuizSession.new(name: "Session ##{current_user.quiz_sessions.count.next}")
  end

  def create
    result = CreateQuizSession.call(user: current_user, **quiz_session_params)

    if result.success?
      redirect_to result.quiz_session
    else
      flash[:error] = result.errors
      redirect_to new_quiz_session_path, status: :unprocessable_entity
    end
  end

  def show
    @quiz_session = QuizSession.find(params[:id])

    if @quiz_session.default?
      render 'quiz_sessions/default/show'
    elsif @quiz_session.synchronous?
      render 'quiz_sessions/synchronous/show'
    end
  end

  private

  def quiz_session_params
    params.require(:quiz_session).permit(:name, :questions_count, :only_free, :session_type)
  end
end
