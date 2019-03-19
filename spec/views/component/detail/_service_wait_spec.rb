require 'rails_helper'

RSpec.describe 'component/detail/service_wait' do
  let(:service) { build(:service) }
  let(:user) { build(:user) }

  before do
    allow(view).to receive(:user_signed_in?) { true }
    render 'component/detail/service_wait', service: service
  end

  it 'will show the wait time estimate label' do
    expect(rendered).to have_content(t('service_fields.availability.service_wait_estimate'))
  end

  it 'will show the correct icon' do
    expect(rendered).to have_selector('.fa.fa-check-circle-o.available')
  end

  it 'will show the correct wait time' do
    expect(rendered).to have_content('Available Today')
  end
end
