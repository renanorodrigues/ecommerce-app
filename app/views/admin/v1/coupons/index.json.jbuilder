json.coupons do
  json.array! @coupons, :id, :name, :due_data, :code, :discount_value, :max_use, :status
end