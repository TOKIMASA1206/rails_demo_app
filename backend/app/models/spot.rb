class Spot < ApplicationRecord
  SORT_ORDERS = {
    "name_asc" => { name: :asc },
    "created_at_desc" => { created_at: :desc }
  }.freeze

  enum :status, {
    want_to_go: "want_to_go",
    visited: "visited"
  }, validate: true

  belongs_to :category
  belongs_to :user
  has_many :spot_tags, dependent: :destroy
  has_many :tags, through: :spot_tags

  validates :name, presence: true
  validates :status, presence: true

  scope :in_category, ->(category_id) { where(category_id: category_id) }
  scope :sorted_by, ->(sort) { order(SORT_ORDERS.fetch(sort)) }

  def self.valid_sort?(sort)
    SORT_ORDERS.key?(sort)
  end
end
