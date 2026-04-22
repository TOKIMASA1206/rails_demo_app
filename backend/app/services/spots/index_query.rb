module Spots
  class IndexQuery
    def initialize(scope: Spot.all, category_id: nil, sort: nil)
      @scope = scope
      @category_id = category_id
      @sort = sort
    end

    def call
      spots = scope
      spots = spots.in_category(category_id) if category_id.present?
      spots = spots.sorted_by(sort) if sort.present?

      spots
    end

    private

    attr_reader :scope, :category_id, :sort
  end
end
