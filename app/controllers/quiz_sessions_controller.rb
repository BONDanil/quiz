class QuizSessionsController < ApplicationController
  def new
    @quiz_session = QuizSession.new
  end

  def create
    @questions = current_user.questions.not_used.sample(params[:count].to_i)
    @quiz_session = QuizSession.new(user: current_user, questions: @questions)

    respond_to do |format|
      if @quiz_session.save
        format.html { redirect_to @quiz_session }
        format.json { render :show, status: :created, location: @quiz_session }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @quiz_session.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
    @quiz_session = QuizSession.find(params[:id])
  end

  private

  def quiz_session_params
    params.require(:quiz_session).permit(:count)
  end
end
