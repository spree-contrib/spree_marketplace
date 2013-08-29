require 'spec_helper'

describe Spree::Supplier do

  it { should have_many(:bank_accounts) }

  it '#balanced_customer_setup' do
    supplier = build :supplier
    supplier.token.should be_nil
    supplier.save!
    supplier.token.should be_present
    supplier = build :supplier, tax_id: '211111111', name: 'Business Name'
    supplier.token.should be_nil
    supplier.save!
    supplier.token.should be_present
  end

  it '#balanced_customer_update should update existing customer records' do
    supplier = build :supplier
    supplier.token.should be_nil
    supplier.save!
    supplier.token.should be_present
    customer = Balanced::Customer.find(supplier.token)
    customer.attributes['ein'].should be_nil
    supplier.tax_id = '211111111'
    supplier.save!
    customer = Balanced::Customer.find(supplier.token)
    customer.attributes['ein'].should eql('211111111')
  end

end
