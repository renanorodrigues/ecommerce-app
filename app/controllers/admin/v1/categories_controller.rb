module Admin::V1
  class CategoriesController < ApiController
    before_action :set_category, only: [:update]

    def index
      @categories = Category.all
    end

    def create
      @category = Category.new(category_params)
      category_save!
    end

    def update
      @category.attributes = category_params
      category_save!
    end

    private

    def category_params
      return {} unless params.has_key?(:category)
      params.require(:category).permit(:id, :name)
    end

    def category_save!
      @category.save!
      render :show
    rescue
      render_error(fields: @category.errors.messages)
    end

    def set_category
      @category = Category.find_by_id(params[:id])
    end
  end
end
