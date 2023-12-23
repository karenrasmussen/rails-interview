class User < ApplicationRecord
  validates :name, presence: true
  validates :email, uniqueness: true
  validates :password, presence: true
  has_many :todo_lists

  def authenticate(entered_password)
    self.password == entered_password
  end
end
