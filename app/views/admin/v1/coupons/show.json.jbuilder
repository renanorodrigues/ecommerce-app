json.coupon do
  json.(@coupon, :id, :name, :due_data, :code, :discount_value, :max_use, :status)
end