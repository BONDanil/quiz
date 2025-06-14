module QuizSessions
  module Synchronous
    class ProcessPlayers
      include Interactor

      delegate :quiz_session, :current_user, to: :context

      def call
        if new_player?
          player = quiz_session.sessions_players.build(
            user: current_user,
            active: true
          )

          if player.save
            quiz_session.broadcast_append_to [quiz_session, quiz_session.host],
                                             target: 'players-host-list',
                                             partial: 'host/quiz_sessions/synchronous/player',
                                             locals: { sessions_player: player }

            quiz_session.broadcast_append_to quiz_session,
                                             target: 'players-list',
                                             partial: 'player/quiz_sessions/player',
                                             locals: { sessions_player: player }
          else
            context.fail!(errors: player.errors)
          end
        end
      end

      private

      def new_player?
        quiz_session.players.exclude?(current_user)
      end
    end
  end
end
