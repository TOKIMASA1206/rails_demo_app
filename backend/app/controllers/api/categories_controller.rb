module Api
  class CategoriesController < ApplicationController

    def create
      category = Category.new(category_params)

      if category.save
        render json: category, status: :created
      else
        render json: { errors: category.errors.full_messages }, status: :unprocessable_entity
      end
    end

    private

    def category_params
      params.require(:category).permit(:name)
    end
  end
end
