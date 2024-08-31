class Player::QuizSessionsController < ApplicationController
  before_action :validate_quiz_session!
  before_action :validate_player!
  layout 'synchronous_quiz'

  def show
    result = QuizSessions::Synchronous::ProcessPlayers.call(
      quiz_session: quiz_session,
      current_user: current_user
    )

    if result.failure?
      redirect_to root_path, notice: result.errors
    else
      render_proper_page
    end
  end

  def answer
    # TODO: move to service
    answer = quiz_session.quiz_answers.build(
      user: current_user,
      question: question,
      text: params[:quiz_answer][:text]
    )

    if answer.save
      quiz_session.broadcast_append_to quiz_session,
                                       target: 'answers-list',
                                       partial: 'host/quiz_sessions/synchronous/answer',
                                       locals: { answer: answer }

      quiz_session.broadcast_replace_to [quiz_session, current_user], target: "player-quiz", template: 'player/quiz_sessions/waiting', locals: { quiz_session: quiz_session, question: }
    else
      render turbo_stream: turbo_stream.replace('answer_form', partial: 'player/quiz_sessions/answer', locals: { answer: answer, quiz_session: quiz_session })
    end
  end

  private

  def render_proper_page
    if quiz_session.pending?
      render 'player/quiz_sessions/pending_session', locals: { quiz_session: quiz_session }
    elsif quiz_session.in_progress?
      if quiz_session.quiz_answers.where(user: current_user, question: question).any?
        render 'player/quiz_sessions/waiting', locals: { quiz_session: quiz_session, question: }
      else
        render 'player/quiz_sessions/in_progress_session', locals: { quiz_session: quiz_session, answer: QuizAnswer.new }
      end
    elsif quiz_session.finished?
      render 'player/quiz_sessions/session_rating', locals: { quiz_session: quiz_session }
    end
  end

  def quiz_session
    @quiz_session ||= QuizSession.find(params[:id])
  end

  def question
    @question ||= quiz_session.current_question
  end

  def validate_quiz_session!
    if quiz_session.default?
      redirect_to root_path, notice: 'For requested quiz url was forbidden'
    elsif quiz_session.user == current_user
      redirect_to quiz_session, notice: 'You are the host of this quiz!'
    end
  end

  def validate_player!
    if quiz_session.sessions_players.where(user: current_user, active: false).any?
      redirect_to root_path, notice: 'You were excluded from that quiz.'
    end
  end
end
