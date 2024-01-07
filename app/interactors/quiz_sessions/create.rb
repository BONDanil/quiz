module QuizSessions
  class Create
    include Interactor

    delegate :user, :name, :only_free, :session_type, :category_ids, to: :context

    def call
      if questions_count.zero?
        context.fail!(errors: "Questions count must be positive number.")
      end

      if category_ids.blank?
        context.fail!(errors: "Must be selected at least one questions category.")
      end

      available_questions_count = available_questions.pluck(:id).count

      if available_questions_count < questions_count
        context.fail!(errors: "Currently only #{available_questions_count} questions can be used. Add more questions or reduce the questions count.")
      end

      random_questions = available_questions.sample(questions_count)

      quiz_session = QuizSession.new(
        user: user,
        name: name,
        questions_count: questions_count,
        session_type: session_type,
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

    def available_questions
      @available_questions ||= begin
        questions = user.questions
        questions = filter_by_categories(questions)
        questions = filter_not_used(questions) if only_free
        questions
      end
    end

    def filter_by_categories(scope)
      scope.where(category_id: category_ids)
    end

    def filter_not_used(scope)
      scope.not_used
    end
  end
end
