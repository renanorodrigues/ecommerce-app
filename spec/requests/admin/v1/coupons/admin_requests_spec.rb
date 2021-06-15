require 'rails_helper'

RSpec.describe 'Admin V1 Coupons as :admin', type: :request do
  let(:user) { create(:user) }

  context 'GET /coupons' do
    let(:url) { '/admin/v1/coupons' }
    let!(:coupons) { create_list(:coupon, 20) }
    before { get url, headers: auth_header(user) }

    it 'returns status ok' do
      expect(response).to have_http_status(:ok) 
    end

    it 'returns all Coupon' do
      expect(body_json['coupons']).to contain_exactly *coupons.as_json(only: %i(id name due_data code discount_value max_use status))
    end
  end

  context 'POST /coupons' do
    let(:url) { '/admin/v1/coupons' }
    
    context 'create Coupon with valid params' do
      let(:coupon_params) { { coupon: attributes_for(:coupon) }.to_json }
      
      it 'increase the total Coupons by one more' do
        expect do
          post url, headers: auth_header(user), params: coupon_params
        end.to change(Coupon, :count).by(1)
      end

      before { post url, headers: auth_header(user), params: coupon_params }

      it 'returns status ok' do
        expect(response).to have_http_status(:ok) 
      end

      it 'returns the last Coupon added' do
        last_coupon = Coupon.last.as_json(only: %i(id name due_data code discount_value max_use status))
        expect(body_json['coupon']).to eq last_coupon
      end
    end

    context 'create Coupon with invalid params' do

      it 'returns status ok' do
        get url, headers: auth_header(user)
        expect(response).to have_http_status(:ok) 
      end
    end
    
  end

  context 'PATCH /coupons/:id' do

  end

  context 'DELETE /coupons/:id' do

  end
end
