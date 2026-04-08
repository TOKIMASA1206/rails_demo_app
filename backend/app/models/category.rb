class Category < ApplicationRecord
  has_many :spots, dependent: :restrict_with_exception

  validates :name, presence: true, uniqueness: true
end
