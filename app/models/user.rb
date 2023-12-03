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
  has_one_attached :profile_picture

  def attach_profile_picture_from_url(url)
    downloaded_file = URI.open(url)

    profile_picture.attach(
      io: downloaded_file,
      filename: 'profile_picture.jpg',
      content_type: downloaded_file.content_type)
  end

  private

  def self.from_google(email:, uid:, image_url:)
    user = User.find_by(email: email)

    return user if user

    password = Devise.friendly_token[0,20]

    user = User.create(email: email,
                password: password,
                nickname: email.split('@').first,
                uid: uid,
                provider: 'google_oauth2')

    user.attach_profile_picture_from_url(image_url)

    UserMailer.with(user: user, password: password).welcome_email.deliver_later

    user
  end
end
