module Admin::V1
  class CategoriesController < ApiController
    before_action :set_category, only: [:show, :update, :destroy]

    def index
      @loading_service = Admin::ModelLoadingService.new(Category.all, searchable_params)
      @loading_service.call
    end

    def show; end

    def create
      @category = Category.new(category_params)
      category_save!
    end

    def update
      @category.attributes = category_params
      category_save!
    end

    def destroy
      @category.destroy!
    rescue
      render_error(fields: @category.errors.messages, status: :no_content)
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

    def searchable_params
      params.permit({ search: :name }, { order: {} }, :page, :length)
    end
  end
end
