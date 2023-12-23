class Item < ApplicationRecord
  validates :name, presence: true
  validates :name, uniqueness: true
  belongs_to :todo_list
end
