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

  def self.sort_order_for(sort)
    SORT_ORDERS[sort]
  end
end
