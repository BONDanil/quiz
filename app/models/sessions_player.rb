class SessionsPlayer < ApplicationRecord
  belongs_to :user
  belongs_to :quiz_session
end
