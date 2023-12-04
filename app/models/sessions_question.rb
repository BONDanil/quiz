class SessionsQuestion < ApplicationRecord
  belongs_to :question
  belongs_to :quiz_session
end
