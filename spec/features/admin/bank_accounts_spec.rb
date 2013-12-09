require 'spec_helper'

feature 'Admin - Supplier Bank Accounts', js: true do

  before do
    country = create(:country, name: "United States")
    create(:state, name: "Vermont", country: country)
  end

  context 'w/Stripe' do

    before do
      SpreeMarketplace::Config[:stripe_publishable_key] = 'pk_test_DIeu8D1IIjLId2xA02TEJthB'
      SpreeMarketplace::Config[:stripe_secret_key] = 'sk_test_2K6AkjxetfMFks2xBoGKB6wy'
    end

    context 'as a Supplier' do

      before do
        login_user create(:supplier_user)
        visit spree.account_path
        within 'dd.supplier-info' do
          click_link 'Edit'
        end
      end

      scenario 'adding bank accounts should work' do
        click_link 'Add Bank Account'
        fill_in 'supplier_bank_account[account_number]', with: '000123456789'
        fill_in 'supplier_bank_account[routing_number]', with: '110000000'
        select2 'United States', from: 'Country'
        click_button 'Save'
        page.should have_content('xxxxxx6789')
        page.should have_content('Supplier bank account "STRIPE TEST BANK" has been successfully created!')
      end

      scenario 'adding invalid bank accounts should display error' do
        click_link 'Add Bank Account'
        fill_in 'supplier_bank_account[account_number]', with: '111111111111'
        fill_in 'supplier_bank_account[routing_number]', with: '110000000'
        select2 'United States', from: 'Country'
        click_button 'Save'
        page.should have_content('Must only use a test bank account number when making transfers in test mode')
      end

    end

  end

end
