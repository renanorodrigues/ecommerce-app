module Admin::V1
  class CouponsController < ApiController
    def index
      @coupons = Coupon.all
    end

    def create
      @coupon = Coupon.new(coupon_params)
      coupon_save!
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
  end
end
