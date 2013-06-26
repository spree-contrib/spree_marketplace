require 'spec_helper'

describe Spree::Supplier do

  it { should have_many(:bank_accounts) }

  it '#set_token' do
    supplier = build :supplier, merchant_type: 'individual'
    supplier.token.should be_nil
    supplier.save
    supplier.token.should be_present
    supplier = build :supplier, tax_id: '211111111', merchant_type: 'business'
    supplier.token.should be_nil
    supplier.save
    supplier.token.should be_present
  end

end
