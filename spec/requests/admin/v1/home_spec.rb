require 'rails_helper'

RSpec.describe "Home", type: :request do
  describe 'GET /home' do
    context 'When user with profile admin access this route' do
      let(:user) { create(:user) }

      it 'returns message expected' do
        get '/admin/v1/home', headers: auth_header(user)
        expect(body_json).to eq({ 'message' => 'Hello, World!' })
      end

      it 'returns status ok' do
        get '/admin/v1/home', headers: auth_header(user)
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
