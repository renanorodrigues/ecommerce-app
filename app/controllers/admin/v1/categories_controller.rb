module Admin::V1
  class CategoriesController < ApiController
    def index
      @categories = Category.all
    end

    def create
      @category = Category.new(category_params)
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
  end
end
