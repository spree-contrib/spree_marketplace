require 'spec_helper'
require 'cancan/matchers'
require 'spree/testing_support/ability_helpers'

describe Spree::MarketplaceAbility do

  let(:user) { create(:user, supplier: create(:supplier)) }
  let(:ability) { Spree::MarketplaceAbility.new(user) }
  let(:token) { nil }

  context 'for SupplierBankAccount' do
    context 'requested by non supplier user' do
      let(:ability) { Spree::MarketplaceAbility.new(create(:user)) }
      let(:resource) { Spree::SupplierBankAccount.new }

      it_should_behave_like 'admin denied'
      it_should_behave_like 'access denied'
    end

    context 'requested by suppliers user' do
      let(:resource) { Spree::SupplierBankAccount.new({supplier: user.supplier}, without_protection: true) }
      it_should_behave_like 'admin granted'
      it_should_behave_like 'access granted'
    end

    context 'requested by another suppliers user' do
      let(:resource) { Spree::SupplierBankAccount.new({supplier: create(:supplier)}, without_protection: true) }
      it_should_behave_like 'create only'
    end
  end

end
