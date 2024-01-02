class QuizSessionChannel < ApplicationCable::Channel
  def subscribed
    @quiz_session = QuizSession.find(params[:id])
    stream_from @quiz_session
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
