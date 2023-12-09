class QuizSessionsController < ApplicationController
  def new
    @quiz_session = QuizSession.new
  end

  def create
    result = CreateQuizSession.call(user: current_user, **filter_params)

    if result.success?
      redirect_to result.quiz_session
    else
      flash.now[:error] = result.errors
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @quiz_session = QuizSession.find(params[:id])
  end

  private

  def quiz_session_params
    params.require(:quiz_session).permit(:questions_count, :only_free)
  end

  def filter_params
    params.permit(:questions_count, :only_free)
  end
end
