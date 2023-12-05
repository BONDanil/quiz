class CreateQuizSession
  include Interactor

  delegate :user, :count_of_questions, to: :context

  def call
    available_questions = user.questions.not_used
    available_questions_count = available_questions.pluck(:id).count

    if available_questions_count < count_of_questions
      context.fail!(errors: "Currently only #{available_questions_count} questions can be used. Add more questions or reduce the number.")
    end

    random_questions = available_questions.sample(count_of_questions)
    quiz_session = QuizSession.new(user: user, questions: random_questions)

    if quiz_session.save
      context.quiz_session = quiz_session
    else
      context.fail!(errors: quiz_session.errors)
    end
  end
end
