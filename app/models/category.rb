class Category < ApplicationRecord
  belongs_to :user
  has_many :questions, dependent: :destroy

  scope :general, -> {
    where(user_id: nil)
  }
end
