module Api
  class SpotsController < ApplicationController
    before_action :validate_sort_param, only: [ :index ]
    before_action :find_spot, only: [ :show, :update, :destroy ]
    before_action :authenticate_user!, only: [ :create, :update, :destroy ]
    before_action :authorize_spot_owner!, only: [ :update, :destroy ]

    def index
      render json: spots_for_index.map { |spot| spot_response(spot) }, status: :ok
    end

    def create
      spot = Spot.new(spot_params.merge(user: current_user))

      if spot.save
        render json: spot_response(spot), status: :created
      else
        render_unprocessable_entity(spot.errors.full_messages)
      end
    end

    def show
      if @spot
        render json: spot_response(@spot), status: :ok
      else
        render_not_found("Spot not found")
      end
    end

    def update
      if @spot.nil?
        render_not_found("Spot not found")
      elsif @spot.update(spot_params)
        render json: spot_response(@spot), status: :ok
      else
        render_unprocessable_entity(@spot.errors.full_messages)
      end
    end

    def destroy
      if @spot.nil?
        render_not_found("Spot not found")
      else
        @spot.destroy
        head :no_content
      end
    end

    private

    def spots_for_index
      Spots::IndexQuery.new(
        category_id: params[:category_id],
        sort: params[:sort]
      ).call
    end

    def find_spot
      @spot = Spot.find_by(id: params[:id])
    end

    def authorize_spot_owner!
      return if @spot.nil?
      return if @spot.user == current_user

      render_forbidden
    end

    def validate_sort_param
      return unless params[:sort].present?
      return if Spot.valid_sort?(params[:sort])

      render_bad_request("Invalid sort parameter")
    end

    def spot_params
      params.require(:spot).permit(:category_id, :name, :note, :url, :status, :visited_on)
    end

    def spot_response(spot)
      spot.as_json(only: %i[
        id
        category_id
        user_id
        name
        note
        url
        status
        visited_on
        created_at
        updated_at
      ])
    end
  end
end
