desc "Change belongs_to to many-to-many sessions-questions"
task reassign_sessions: :environment do
  Question.find_each do |question|
    quiz_session = question.quiz_session

    unless quiz_session.nil?
      SessionsQuestion.create(
        question: question,
        quiz_session: quiz_session
      )
    end
  end
end
