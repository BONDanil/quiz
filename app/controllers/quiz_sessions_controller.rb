class QuizSessionsController < ApplicationController
  before_action :validate_user!, only: %i[show start]

  def new
    @quiz_session = QuizSession.new(name: "Session ##{current_user.quiz_sessions.count.next}")
  end

  def create
    result = QuizSessions::Create.call(user: current_user, **quiz_session_params)

    if result.success?
      redirect_to result.quiz_session
    else
      flash[:error] = result.errors
      redirect_to new_quiz_session_path, status: :unprocessable_entity
    end
  end

  def show
    if quiz_session.default?
      render 'quiz_sessions/default/show'
    elsif quiz_session.synchronous?
      render_proper_page
    end
  end

  def start
    # TODO: move to service
    quiz_session.update(status: :in_progress)
    quiz_session.broadcast_replace_to quiz_session, target: 'host-quiz', template: 'quiz_sessions/synchronous/in_progress_session', locals: { quiz_session: quiz_session }
    quiz_session.broadcast_replace_to quiz_session, target: 'player-quiz', template: 'player/quiz_sessions/in_progress_session', locals: { quiz_session: quiz_session }
  end

  private

  def validate_user!
    if quiz_session.user != current_user
      redirect_to root_path, notice: 'You are not a host!'
    end
  end

  def render_proper_page
    if quiz_session.pending?
      render 'quiz_sessions/synchronous/pending_session'
    elsif quiz_session.in_progress?
      render 'quiz_sessions/synchronous/in_progress_session'
    elsif quiz_session.finished?
      render 'quiz_sessions/synchronous/session_rating'
    end
  end

  def quiz_session
    @quiz_session ||= QuizSession.find(params[:id])
  end

  def quiz_session_params
    params.require(:quiz_session).permit(:name, :questions_count, :only_free, :session_type)
  end
end
