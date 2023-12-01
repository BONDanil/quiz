class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]
  validates :nickname, uniqueness: true

  has_many :quiz_sessions, dependent: :destroy
  has_many :categories, dependent: :destroy
  has_many :questions, dependent: :destroy

  private

  def self.from_google(email:, uid: )
    user = User.find_by(email: email)

    return user if user

    User.create(email: email,
                password: Devise.friendly_token[0,20],
                nickname: email.split('@').first,
                uid: uid,
                provider: 'google_oauth2')
  end
end
