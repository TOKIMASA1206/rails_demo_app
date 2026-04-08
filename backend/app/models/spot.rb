class Spot < ApplicationRecord
  enum :status, {
    want_to_go: "want_to_go",
    visited: "visited"
  }, validate: true

  belongs_to :category

  validates :name, presence: true
  validates :status, presence: true
end
