require 'rails_helper'

RSpec.describe "Admin V1 User without authenticate", type: :request do
  context 'GET /users' do
    let(:url) { '/admin/v1/users' }
    let(:users) { create_list(:user, 5) }
    before { get url }
    include_examples 'unauthenticated access'
  end

  context 'POST /users' do
    let(:url) { '/admin/v1/users' }
    before { post url }
    include_examples 'unauthenticated access'
  end

  context 'PATCH /users' do
    let(:user) { create(:user) }
    let(:url) { "/admin/v1/users/#{user.id}" }
    before { patch url }
    include_examples 'unauthenticated access'
  end

  context 'DELETE /users' do
    let(:user) { create(:user) }
    let(:url) { "/admin/v1/users/#{user.id}" }
    before { delete url }
    include_examples 'unauthenticated access'
  end
end
