module Api
  class SpotsController < ApplicationController
    def index
      spots = Spot.all
      render json: spots, status: :ok
    end

    def create
      spot = Spot.new(spot_params)

      if spot.save
        render json: spot, status: :created
      else
        render json: { errors: spot.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def show
      spot = Spot.find_by(id: params[:id])

      if spot
        render json: spot, status: :ok
      else
        render json: { errors: ["Spot not found"] }, status: :not_found
      end
    end

    def update
      spot = Spot.find_by(id: params[:id])

      if spot.nil?
        render json: { errors: ["Spot not found"] }, status: :not_found
      elsif spot.update(spot_params)
        render json: spot, status: :ok
      else
        render json: { errors: spot.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def destroy
      spot = Spot.find_by(id: params[:id])
      if spot.nil?
        render json: { errors: ["Spot not found"] }, status: :not_found
      else
        spot.destroy
        head :no_content
      end
    end

    private

    def spot_params
      params.require(:spot).permit(:category_id, :name, :note, :url, :status, :visited_on)
    end
  end
end
