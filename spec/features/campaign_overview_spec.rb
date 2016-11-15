# frozen_string_literal: true
require 'rails_helper'

describe 'campaign overview page', type: :feature, js: true do
  let(:slug)  { 'spring_2016' }
  let(:admin) { create(:admin) }
  let(:campaign) {
    create(:campaign,
           id: 10001,
           title: 'My awesome Spring 2016 campaign',
           slug: slug,
           description: 'This is the best campaign')
  }

  before do
    Capybara.current_driver = :poltergeist
    stub_token_request
  end

  before :each do
    login_as(admin, scope: :user)
  end

  context 'updating a campaign' do
    before do
      visit "/campaigns/#{campaign.slug}"
      sleep 1
    end

    it 'shows the description input field when in edit mode' do
      find('.campaign-description .editable-edit').click
      find('#campaign_description', visible: true)
    end

    it 'updates the campaign when you click save' do
      find('.campaign-description .editable-edit').click
      fill_in('campaign_description', with: 'This is my new description')
      find('.campaign-description .editable-save').click
      expect(campaign.reload.description).to eq('This is my new description')
    end
  end
end
