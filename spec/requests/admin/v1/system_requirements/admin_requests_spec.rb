require 'rails_helper'

RSpec.describe 'Admin V1 System Requirements access as admin', type: :request do
  let(:user) { create(:user) }

  context 'GET /system_requirements' do
    let(:url) { '/admin/v1/system_requirements' }
    let!(:system_requirements) { create_list(:system_requirement, 10) }
    
    before(:each) { get url, headers: auth_header(user) }

    it 'returns status ok' do
      expect(response).to have_http_status(:ok)  
    end

    it 'returns all System Requirements' do
      expect(body_json['system_requirements']).to contain_exactly *system_requirements.as_json(only: %i(id name storage processor memory video_board operational_system)) 
    end
  end

  context 'POST /system_requirements' do
    let(:url) { '/admin/v1/system_requirements' }
    
    context 'with valid params' do
      let(:system_requirement_params) do
        { system_requirements: attributes_for(:system_requirement) }.to_json
      end

      it 'creates the System Requirements and change total count one plus' do
        expect do
          post url, headers: auth_header(user), params: system_requirement_params
        end.to change(SystemRequirement, :count).by(1)
      end

      it 'returns last System Requirements' do
        post url, headers: auth_header(user), params: system_requirement_params
        last_system_requirement = SystemRequirement.last.as_json(only: %i(id name storage processor memory video_board operational_system))
        expect(body_json['system_requirements']).to eq last_system_requirement
      end

      it 'returns status ok' do
        post url, headers: auth_header(user), params: system_requirement_params
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid params' do
      let(:system_requirement_invalid_params) do
        { system_requirements: attributes_for(:system_requirement, name: nil) }.to_json
      end

      it 'don\'t creates the System Requirements' do
        expect do
          post url, headers: auth_header(user), params: system_requirement_invalid_params
        end.to change(SystemRequirement, :count).by(0)
      end

      it 'returns status unprocessable_entity' do
        post url, headers: auth_header(user), params: system_requirement_invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns errors messages' do
        post url, headers: auth_header(user), params: system_requirement_invalid_params
        expect(body_json['errors']['fields']).to have_key('name')
      end
    end
  end

  context 'PATCH /system_requirements/:id' do
    let(:system_requirement) { create(:system_requirement) }
    let(:url) { "/admin/v1/system_requirements/#{system_requirement.id}" }

    context 'with valid params' do
      let(:new_name) { "MegazordX" }
      let(:system_requirement_update_params) { {system_requirements: { name: new_name } }.to_json }

      before do
        patch url, headers: auth_header(user), params: system_requirement_update_params
        system_requirement.reload
      end

      it 'returns status ok' do
        expect(response).to have_http_status(:ok)  
      end

      it 'matchs the last system requirement attribute updated with params' do
        expect(system_requirement.name).to eq new_name
      end

      it 'returns the last system requirement updated' do
        expect(body_json['system_requirements']).to eq system_requirement.as_json(only: %i(id name storage processor memory video_board operational_system))
      end
    end

    context 'with invalid params' do
      let(:system_requirement_invalid_update_params) do
        { system_requirements: attributes_for(:system_requirement, name: nil) }.to_json
      end

      it 'returns status unprocessable_entity' do
        patch url, headers: auth_header(user), params: system_requirement_invalid_update_params
        expect(response).to have_http_status(:unprocessable_entity)  
      end

      it 'returns error message' do
        patch url, headers: auth_header(user), params: system_requirement_invalid_update_params
        expect(body_json['errors']['fields']).to have_key('name')
      end

      it 'returns the last system requirement updated' do
        old_name = system_requirement.name
        patch url, headers: auth_header(user), params: system_requirement_invalid_update_params
        system_requirement.reload
        expect(system_requirement.name).to eq old_name
      end
    end
  end

  context 'DELETE /system_requirements/:id' do
    let!(:system_requirement) { create(:system_requirement) }
    let(:url) { "/admin/v1/system_requirements/#{system_requirement.id}" }

    it 'decrements by one total count SystemRequirement' do
      expect do
        delete url, headers: auth_header(user)
      end.to change(SystemRequirement, :count).by(-1)
    end

    it 'return status no_content' do
      delete url, headers: auth_header(user)
      expect(response).to have_http_status(:no_content)
    end

    it 'don\'t return the same object after deleted' do
      delete url, headers: auth_header(user)
      expect(body_json).to_not be_present
    end

    it 'don\'t delete if exists associations' do
      associations_games = create_list(:game, 3, system_requirement: system_requirement)
      delete url, headers: auth_header(user)
      expected_associations = Game.where(id: associations_games.map(&:id))
      expect(expected_associations.count).to eq 3
    end
  end
end
