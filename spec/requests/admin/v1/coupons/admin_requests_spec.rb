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
    
    context 'create with valid params' do
      let(:coupon_params) { { coupon: attributes_for(:coupon) }.to_json }
      
      it 'increase the total Coupons by one more' do
        expect do
          post url, headers: auth_header(user), params: coupon_params
        end.to change(Coupon, :count).by(1)
      end

      it 'returns status ok' do
        post url, headers: auth_header(user), params: coupon_params
        expect(response).to have_http_status(:ok) 
      end

      it 'returns the last Coupon added' do
        post url, headers: auth_header(user), params: coupon_params
        last_coupon = Coupon.last.as_json(only: %i(id name due_data code discount_value max_use status))
        expect(body_json['coupon']).to eq last_coupon
      end
    end

    context 'with invalid params' do
      let(:invalid_coupon_params) do
        { coupon: attributes_for(:coupon, name: nil) }.to_json
      end

      it 'don\'t change total count of Coupons' do
        expect do
          post url, headers: auth_header(user), params: invalid_coupon_params
        end.to change(Coupon, :count).by(0)
      end

      it 'returns error message' do
        post url, headers: auth_header(user), params: invalid_coupon_params
        expect(body_json['errors']['fields']).to have_key('name')
      end

      it 'returns status unprocessable_entity' do
        post url, headers: auth_header(user), params: invalid_coupon_params
        expect(response).to have_http_status(:unprocessable_entity) 
      end
    end
    
  end

  context 'PATCH /coupons/:id' do
    let!(:coupon) { create(:coupon) }
    let(:url) { "/admin/v1/coupons/#{coupon.id}" }

    context 'with valid params' do
      let(:name) { 'Chrono Trigger Coupon' }
      let(:coupon_params) { { coupon: { name: name } }.to_json }

      it 'updates a Coupon' do
        patch url, headers: auth_header(user), params: coupon_params
        coupon.reload
        expect(coupon.name).to eq name
      end

      it 'returns status ok' do
        patch url, headers: auth_header(user), params: coupon_params
        expect(response).to have_http_status(:ok) 
      end

      it 'returns the last Coupon added' do
        patch url, headers: auth_header(user), params: coupon_params
        coupon.reload
        last_coupon = Coupon.last.as_json(only: %i(id name due_data code discount_value max_use status))
        expect(body_json['coupon']).to eq last_coupon
      end
    end

    context 'with invalid params' do
      let(:invalid_coupon_params) do
        { coupon: attributes_for(:coupon, name: nil) }.to_json
      end

      it 'doesn\'t update Coupon' do
        old_name = coupon.name
        patch url, headers: auth_header(user), params: invalid_coupon_params
        coupon.reload
        expect(coupon.name).to eq old_name
      end

      it 'returns error message' do
        patch url, headers: auth_header(user), params: invalid_coupon_params
        expect(body_json['errors']['fields']).to have_key('name')
      end

      it 'returns status unprocessable_entity' do
        patch url, headers: auth_header(user), params: invalid_coupon_params
        expect(response).to have_http_status(:unprocessable_entity) 
      end
    end
  end

  context 'DELETE /coupons/:id' do
    let!(:coupon) { create(:coupon) }
    let(:url) { "/admin/v1/coupons/#{coupon.id}" }
    
    it 'delete the Coupon' do
      expect do
        delete url, headers: auth_header
      end.to change(Coupon, :count).by(-1)
    end

    it 'returns status no_content' do
      delete url, headers: auth_header
      expect(response).to have_http_status(:no_content)
    end
  end
end
