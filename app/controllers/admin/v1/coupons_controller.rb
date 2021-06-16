module Admin::V1
  class CouponsController < ApiController
    before_action :set_coupon, only: [:update, :destroy]

    def index
      @coupons = Coupon.all
    end

    def create
      @coupon = Coupon.new(coupon_params)
      coupon_save!
    end

    def update
      @coupon.attributes = coupon_params
      coupon_save!
    end

    def destroy
      @coupon.destroy!
    rescue
      render_error(fields: @coupon.errors.messages, status: :no_content)
    end

    private

    def coupon_params
      return {} unless params.has_key?(:coupon)
      params.require(:coupon).permit(:id, :name, :due_data, :code, :discount_value, :max_use, :status)
    end

    def coupon_save!
      @coupon.save!
      render :show
    rescue
      render_error(fields: @coupon.errors.messages)
    end

    def set_coupon
      @coupon = Coupon.find_by_id(params[:id])
    end
  end
end
