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
            player.broadcast_append_to :players,
                                       target: 'players-list',
                                       partial: 'quiz_sessions/synchronous/player',
                                       locals: { player: current_user }
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
