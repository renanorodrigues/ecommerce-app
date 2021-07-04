require 'rails_helper'

RSpec.describe 'Admin V1 Users access as admin', type: :request do
  let!(:user_admin) { create(:user) }

  context 'GET /users' do
    let!(:users) { create_list(:user, 5) }
    let(:url) { '/admin/v1/users' }
    before { get url, headers: auth_header(user_admin) }

    it 'returns status ok' do
      expect(response).to have_http_status(:ok)  
    end

    it 'returns all users' do
      expect_all_users = User.all.as_json(only: %i(id name email profile))
      expect(body_json['users']).to contain_exactly *expect_all_users
    end
  end

  context 'POST /users' do
    let(:url) { '/admin/v1/users' }

    context 'with valid params' do
      let(:user_params) do
        { user: attributes_for(:user) } .to_json
      end

      it 'returns status ok' do
        post url, headers: auth_header(user_admin), params: user_params
        expect(response).to have_http_status(:ok)
      end

      it 'return the last created' do
        post url, headers: auth_header(user_admin), params: user_params
        expect_user = User.last.as_json(only: %i(id name email profile))
        expect(body_json['user']).to eq expect_user
      end

      it 'creates the User' do
        expect do
          post url, headers: auth_header(user_admin), params: user_params
        end.to change(User, :count).by(1)
      end
    end

    context 'with invalid params' do
      let(:user_invalid_params) do
        { user: attributes_for(:user, name: nil) } .to_json
      end

      it 'returns status unprocessable_entity' do
        post url, headers: auth_header(user_admin), params: user_invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'don\'t creates the User' do
        expect do
          post url, headers: auth_header(user_admin), params: user_invalid_params
        end.to_not change(User, :count)
      end

      it 'returns message errors' do
        post url, headers: auth_header(user_admin), params: user_invalid_params
        expect(body_json['errors']['fields']).to have_key('name')
      end
    end
  end

  context 'PATCH /users/:id' do
    let(:user) { create(:user) }
    let(:url) { "/admin/v1/users/#{user.id}" }

    context 'with valid params' do
      let(:new_name) { 'Silvestre Istalony' }
      let(:user_params) do
        { user: { name: new_name } }.to_json
      end

      it 'return the User updated with the new value' do
        patch url, headers: auth_header(user_admin), params: user_params
        user.reload
        expect(user.name).to eq new_name 
      end

      it 'return the User updated' do
        patch url, headers: auth_header(user_admin), params: user_params
        user.reload
        expect_user = user.as_json(only: %i(id name email profile))
        expect(body_json['user']).to eq expect_user
      end

      it 'returns status ok' do
        patch url, headers: auth_header(user_admin), params: user_params
        expect(response).to have_http_status(:ok)  
      end
    end

    context 'with invalid params' do
      let(:user_invalid_params) do
        { user: { name: nil } }.to_json
      end

      it 'don\'t update the attribute' do
        old_name = user.name
        patch url, headers: auth_header(user_admin), params: user_invalid_params
        user.reload
        expect(user.name).to eq old_name
      end

      it 'returns status unprocessable_entity' do
        patch url, headers: auth_header(user_admin), params: user_invalid_params
        expect(response).to have_http_status(:unprocessable_entity)  
      end

      it 'returns error messages' do
        patch url, headers: auth_header(user_admin), params: user_invalid_params
        expect(body_json['errors']['fields']).to have_key('name') 
      end
    end
  end

  context 'DELETE /users/:id' do
    let!(:user) { create(:user) }
    let(:url) { "/admin/v1/users/#{user.id}" }

    it 'change total count by -1 after delete user' do
      expect do
        delete url, headers: auth_header(user_admin)
      end.to change(User, :count).by(-1)
    end
    
    it 'returns status no_content' do
      delete url, headers: auth_header(user_admin)
      expect(response).to have_http_status(:no_content)
    end

    it 'don\'t return any body content' do
      delete url, headers: auth_header(user_admin)
      expect(body_json).to_not be_present
    end
  end
end
