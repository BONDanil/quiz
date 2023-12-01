class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :nickname, uniqueness: true

  has_many :quiz_sessions, dependent: :destroy
  has_many :categories, dependent: :destroy
  has_many :questions, dependent: :destroy
end
