module Api
  class CategoriesController < ApplicationController
    before_action :find_category, only: [ :update, :destroy ]

    def index
      categories = Category.all
      render json: categories.map { |category| category_response(category) }, status: :ok
    end

    def create
      category = Category.new(category_params)

      if category.save
        render json: category_response(category), status: :created
      else
        render json: { errors: category.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def update
      if @category.nil?
        render json: { errors: [ "Category not found" ] }, status: :not_found
      elsif @category.update(category_params)
        render json: category_response(@category), status: :ok
      else
        render json: { errors: @category.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def destroy
      if @category.nil?
        render json: { errors: [ "Category not found" ] }, status: :not_found
      else
        @category.destroy
        head :no_content
      end
    rescue ActiveRecord::DeleteRestrictionError
      render json: { errors: [ "Cannot delete category with associated spots" ] }, status: :unprocessable_entity
    end

    private

    def find_category
      @category = Category.find_by(id: params[:id])
    end

    def category_params
      params.require(:category).permit(:name)
    end

    def category_response(category)
      category.as_json(only: %i[
        id
        name
        created_at
        updated_at
      ])
    end
  end
end
