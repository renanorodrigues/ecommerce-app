require 'rails_helper'

RSpec.describe "Admin V1 Licenses as :admin", type: :request do
  let(:user) { create(:user) }

  context "GET /licenses" do
    let(:url) { "/admin/v1/licenses" }
    let!(:licenses) { create_list(:license, 10) }
    
    it "returns 10 Licenses" do
      get url, headers: auth_header(user)
      expect(body_json['licenses'].count).to eq 10
    end
    
    it "returns 10 first Licenses" do
      get url, headers: auth_header(user)
      expected_licenses = licenses[0..9].as_json(only: %i(id key status platform game_id user_id))
      expect(body_json['licenses']).to contain_exactly *expected_licenses
    end

    it "returns success status" do
      get url, headers: auth_header(user)
      expect(response).to have_http_status(:ok)
    end
  end

  context "POST /licenses" do
    let(:url) { '/admin/v1/licenses' }

    context 'with valid params' do
      let!(:game) { create(:game) }
      let!(:user) { create(:user) }
      let!(:license_params) do
        { license: attributes_for(:license, game_id: game.id, user_id: user.id) }.to_json
      end

      it 'return status ok' do
        post url, headers: auth_header(user), params: license_params
        expect(response).to have_http_status(:ok)  
      end

      it 'create License' do
        expect do
          post url, headers: auth_header(user), params: license_params
        end.to change(License, :count).by(1)
      end

      it 'return expected License' do
        post url, headers: auth_header(user), params: license_params
        last_license_created = License.last.as_json(only: %i(id key status platform game_id user_id))  
        expect(body_json['license']).to eq last_license_created
      end
    end

    context 'with invalid params' do
      let(:license_invalid_params) do
        { license: attributes_for(:license) }.to_json
      end

      it 'return status unprocessable_entity' do
        post url, headers: auth_header(user), params: license_invalid_params
        expect(response).to have_http_status(:unprocessable_entity)  
      end

      it 'don\'t create License' do
        expect do
          post url, headers: auth_header(user), params: license_invalid_params
        end.to_not change(License, :count)
      end

      it 'return message error' do
        post url, headers: auth_header(user), params: license_invalid_params  
        expect(body_json['errors']['fields']).to have_key('game')
      end
    end
  end

  context "GET /licenses/:id" do
    let(:license) { create(:license) }
    let(:url) { "/admin/v1/licenses/#{license.id}" }

    it 'return status ok' do
      get url, headers: auth_header(user)
      expect(response).to have_http_status(:ok)  
    end

    it 'return expected License' do
      get url, headers: auth_header(user)
      expect(body_json['license']).to eq license.as_json(only: %i(id key status platform game_id user_id))  
    end
  end

  context "PATCH /licenses/:id" do
    let(:game) { create(:game) }
    let(:user) { create(:user) }
    let(:license) { create(:license, game: game, user: user) }
    let(:url) { "/admin/v1/licenses/#{license.id}" }

    context "with valid params" do
      let(:new_key) { "SteamGold" }
      let(:license_params) { { key: new_key }.to_json }

      it 'return status ok' do
        patch url, headers: auth_header(user), params: license_params
        expect(response).to have_http_status(:ok)  
      end

      it 'expect the attribute updated' do
        patch url, headers: auth_header(user), params: license_params
        license.reload
        expect(license.key).to eq new_key
      end
  
      it 'return expected License' do
        patch url, headers: auth_header(user), params: license_params
        license.reload
        expect(body_json['license']).to eq license.as_json(only: %i(id key status platform game_id user_id))  
      end
    end

    context "with invalid params" do
      let(:license_invalid_params) { { key: nil }.to_json }

      it 'return status unprocessable_entity' do
        patch url, headers: auth_header(user), params: license_invalid_params
        expect(response).to have_http_status(:unprocessable_entity)  
      end

      it 'expect the attribute not updated' do
        old_key = license.key
        patch url, headers: auth_header(user), params: license_invalid_params
        license.reload
        expect(license.key).to eq old_key
      end

      it 'return message error' do
        patch url, headers: auth_header(user), params: license_invalid_params  
        expect(body_json['errors']['fields']).to have_key('key')
      end
  
      it 'return expected License' do
        patch url, headers: auth_header(user), params: license_invalid_params
        expect(body_json['license']).to_not be_present
      end
    end
  end

  context "DELETE /licenses/:id" do
    let!(:license) { create(:license) }
    let(:url) { "/admin/v1/licenses/#{license.id}" }

    it 'deletes the License' do
      expect do
        delete url, headers: auth_header(user)
      end.to change(License, :count).by(-1)
    end

    it 'return no_content status' do
      delete url, headers: auth_header(user)
      expect(response).to have_http_status(:no_content)  
    end

    it 'don\'t returns License' do
      delete url, headers: auth_header(user)
      expect(body_json['license']).to_not be_present
    end
  end
end
