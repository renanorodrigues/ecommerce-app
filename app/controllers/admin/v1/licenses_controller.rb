module Admin::V1
  class LicensesController < ApiController
    before_action :set_license, only: %i(show update destroy)
    def index
      @licenses = License.all
    end

    def show; end

    def create
      @license = License.new(license_params)
      license_save!
    end

    def update
      @license.attributes = license_params
      license_save!
    end

    def destroy
      @license.destroy!
    rescue
      render_error(fields: @license.errors.messages, status: :no_content)
    end

    private

    def set_license
      @license = License.find_by_id(params[:id])
    end

    def license_params
      return {} unless params.has_key?(:license)
      params.require(:license).permit(:id, :key, :game_id, :user_id)
    end

    def license_save!
      @license.save!
      render :show
    rescue
      render_error(fields: @license.errors.messages)
    end
  end
end
