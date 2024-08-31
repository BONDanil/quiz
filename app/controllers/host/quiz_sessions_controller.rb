class Host::QuizSessionsController < ApplicationController
  before_action :validate_user!, except: %i[new create]
  layout 'synchronous_quiz', except: %i[new]

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
      render 'host/quiz_sessions/default/show', layout: 'application'
    elsif quiz_session.synchronous?
      render_proper_page
    end
  end

  def start
    # TODO: move to service
    # TODO: change to render_later
    quiz_session.update!(status: :in_progress)

    quiz_session.broadcast_replace_to [quiz_session, current_user], target: 'host-quiz', template: 'host/quiz_sessions/synchronous/in_progress_session', locals: { quiz_session: quiz_session }
    quiz_session.broadcast_replace_to quiz_session, target: 'player-quiz', template: 'player/quiz_sessions/in_progress_session', locals: { quiz_session: quiz_session, answer: QuizAnswer.new }
  end

  def mark_answer
    answer = QuizAnswer.find(params[:quiz_answer][:id])

    if answer
      answer.update!(correct: params[:quiz_answer][:correct])
      quiz_session.broadcast_replace_to [quiz_session, current_user], target: helpers.dom_id(answer, :answer), partial: 'host/quiz_sessions/synchronous/mark_answer_form', locals: { answer: }
    end
  end

  def next
    quiz_session.increment!(:current_question_index)

    quiz_session.broadcast_replace_to [quiz_session, current_user], target: 'host-quiz', template: 'host/quiz_sessions/synchronous/in_progress_session', locals: { quiz_session: quiz_session }
    quiz_session.broadcast_replace_to quiz_session, target: 'player-quiz', template: 'player/quiz_sessions/in_progress_session', locals: { quiz_session: quiz_session, answer: QuizAnswer.new }
  end

  def rating
    if quiz_session.current_question_index + 1 == quiz_session.questions_count
      quiz_session.finished!
    end

    quiz_session.broadcast_replace_to [quiz_session, current_user], target: 'host-quiz', template: 'host/quiz_sessions/synchronous/session_rating', locals: { quiz_session: quiz_session }
    quiz_session.broadcast_replace_to quiz_session, target: 'player-quiz', template: 'player/quiz_sessions/session_rating', locals: { quiz_session: quiz_session }
    head :ok
  end

  def deactivate_player
    sessions_player = SessionsPlayer.find(params[:sessions_player][:id])

    if sessions_player
      sessions_player.update!(active: false)
    end

    quiz_session.broadcast_replace_to [quiz_session, current_user], target: helpers.dom_id(sessions_player, :player), partial: 'host/quiz_sessions/synchronous/activate_player_form', locals: { sessions_player: sessions_player }
    # TODO: replace and rename to 'player/excluded_page'
    quiz_session.broadcast_replace_to [quiz_session, sessions_player.user], target: 'player-quiz', template: 'host/quiz_sessions/synchronous/eliminated_page'
  end

  def activate_player
    sessions_player = SessionsPlayer.find(params[:sessions_player][:id])

    if sessions_player
      sessions_player.update!(active: true)
    end

    quiz_session.broadcast_replace_to [quiz_session, current_user], target: helpers.dom_id(sessions_player, :player), partial: 'host/quiz_sessions/synchronous/deactivate_player_form', locals: { sessions_player: sessions_player }
  end

  private

  def validate_user!
    if quiz_session.user != current_user
      redirect_to root_path, notice: 'You are not a host!'
    end
  end

  def render_proper_page
    if quiz_session.pending?
      # TODO: refactor it (maybe use has_one :svg or just replace it to method)
      quiz_play_url = url_for(quiz_session) + '/play'
      qrcode = RQRCode::QRCode.new(quiz_play_url)
      svg = qrcode.as_svg(color: "000", shape_rendering: "crispEdges", module_size: 5, standalone: true, use_path: true)
      render 'host/quiz_sessions/synchronous/pending_session', locals: { quiz_session: quiz_session, quiz_play_url: quiz_play_url, svg: svg }
    elsif quiz_session.in_progress?
      render 'host/quiz_sessions/synchronous/in_progress_session', locals: { quiz_session: quiz_session }
    elsif quiz_session.finished?
      render 'host/quiz_sessions/synchronous/session_rating', locals: { quiz_session: quiz_session }
    end
  end

  def quiz_session
    @quiz_session ||= QuizSession.find(params[:id])
  end

  def quiz_session_params
    params.require(:quiz_session).permit(:name, :questions_count, :only_free, :session_type, category_ids: [])
  end
end
