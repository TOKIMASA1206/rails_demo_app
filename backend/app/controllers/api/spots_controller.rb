module Api
  class SpotsController < ApplicationController

    def create
      spot = Spot.new(spot_params)

      if spot.save
        render json: spot, status: :created
      else
        render json: { errors: spot.errors.full_messages }, status: :unprocessable_entity
      end
    end

    private

    def spot_params
      params.require(:spot).permit(:category_id, :name, :note, :url, :status, :visited_on)
    end
  end
end
