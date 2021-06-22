require 'rails_helper'

RSpec.describe 'Admin V1 System Requirements as client', type: :request do
  let(:user) { create(:user, profile: :client) }

  context 'GET /system_requirements' do
    let(:url) { "/admin/v1/system_requirements" }
    let(:system_requirements) { create_list(:system_requirement, 10) }
    before { get url, headers: auth_header(user) }
    include_examples 'forbidden access'
  end

  context 'POST /system_requirements' do
    let(:url) { "/admin/v1/system_requirements" }
    before { post url, headers: auth_header(user) }
    include_examples 'forbidden access'
  end

  context 'PATCH /system_requirements/:id' do
    let(:system_requirement) { create(:system_requirement) }
    let(:url) { "/admin/v1/system_requirements/#{system_requirement.id}" }
    before { patch url, headers: auth_header(user) }
    include_examples 'forbidden access'
  end

  context 'DELETE /system_requirements/:id' do
    let(:system_requirement) { create(:system_requirement) }
    let(:url) { "/admin/v1/system_requirements/#{system_requirement.id}" }
    before { delete url, headers: auth_header(user) }
    include_examples 'forbidden access'
  end
end
