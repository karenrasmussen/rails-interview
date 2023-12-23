class TodoList < ApplicationRecord
  validates :name, presence: true
  validates :name, uniqueness: true
  belongs_to :user
  has_many :items
end
