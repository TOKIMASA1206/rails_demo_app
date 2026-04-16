module Api
  class SpotsController < ApplicationController
    before_action :validate_sort_param, only: [ :index ]
    before_action :find_spot, only: [ :show, :update, :destroy ]

    def index
      render json: spots_for_index, status: :ok
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
      if @spot
        render json: @spot, status: :ok
      else
        render json: { errors: [ "Spot not found" ] }, status: :not_found
      end
    end

    def update
      if @spot.nil?
        render json: { errors: [ "Spot not found" ] }, status: :not_found
      elsif @spot.update(spot_params)
        render json: @spot, status: :ok
      else
        render json: { errors: @spot.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def destroy
      if @spot.nil?
        render json: { errors: [ "Spot not found" ] }, status: :not_found
      else
        @spot.destroy
        head :no_content
      end
    end

    private

    def spots_for_index
      spots = Spot.all
      spots = spots.where(category_id: params[:category_id]) if params[:category_id].present?

      sort_order = Spot.sort_order_for(params[:sort])
      sort_order ? spots.order(sort_order) : spots
    end

    def find_spot
      @spot = Spot.find_by(id: params[:id])
    end

    def validate_sort_param
      return unless params[:sort].present?
      return if Spot.sort_order_for(params[:sort])

      render json: { errors: [ "Invalid sort parameter" ] }, status: :bad_request
    end

    def spot_params
      params.require(:spot).permit(:category_id, :name, :note, :url, :status, :visited_on)
    end
  end
end
