class CreateQuizSession
  include Interactor

  delegate :user, :name, :only_free, to: :context

  def call
    if questions_count.zero?
      context.fail!(errors: "Questions count must be positive number.")
    end

    available_questions = filtered_questions
    available_questions_count = available_questions.pluck(:id).count

    if available_questions_count < questions_count
      context.fail!(errors: "Currently only #{available_questions_count} questions can be used. Add more questions or reduce the questions count.")
    end

    random_questions = available_questions.sample(questions_count)

    quiz_session = QuizSession.new(
      user: user,
      name: name,
      questions_count: questions_count,
      questions: random_questions
    )

    context.quiz_session = quiz_session

    unless quiz_session.save
      context.fail!(errors: quiz_session.errors)
    end
  end

  private

  def questions_count
    @questions_count ||= context.questions_count.to_i
  end

  def filtered_questions
    questions = user.questions
    questions = user.questions.not_used if only_free
    questions
  end
end
