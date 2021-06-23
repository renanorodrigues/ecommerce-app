require 'rails_helper'

RSpec.describe 'Admin V1 Users access as client', type: :request do
  let(:user) { create(:user, profile: :client) }

  context 'GET /users' do
    let(:users) { create_list(:user, 5) }
    let(:url) { '/admin/v1/users' }
    before { get url, headers: auth_header(user) }
    include_examples 'forbidden access'
  end

  context 'POST /users' do
    let(:url) { '/admin/v1/users' }
    before { post url, headers: auth_header(user) }
    include_examples 'forbidden access'
  end

  context 'PATCH /users/:id' do
    let(:new_user) { create(:user) }
    let(:url) { "/admin/v1/users/#{new_user.id}" }
    before { patch url, headers: auth_header(user) }
    include_examples 'forbidden access'
  end

  context 'DELETE /users/:id' do
    let(:object_user) { create(:user) }
    let(:url) { "/admin/v1/users/#{object_user.id}" }
    before { delete url, headers: auth_header(user) }
    include_examples 'forbidden access'
  end
end
