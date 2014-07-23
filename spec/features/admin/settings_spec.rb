require 'spec_helper'

describe 'Admin - Marketplace Settings', js: true do

  before do
    login_user create(:admin_user)

    visit spree.admin_path
    within 'ul[data-hook=admin_tabs]' do
      click_link 'Configuration'
    end
    within 'ul[data-hook=admin_configurations_sidebar_menu]' do
      click_link 'Marketplace Settings'
    end
  end

  it 'should be able to be updated' do
    # Change settings
    check 'allow_signup'
    click_button 'Update'
    expect(page).to have_content('Marketplace settings successfully updated.')

    # Verify update saved properly by reversing checkboxes or checking field values.
    uncheck 'allow_signup'
    click_button 'Update'
    expect(page).to have_content('Marketplace settings successfully updated.')
  end

end
