require 'spree_drop_ship/factories'

FactoryGirl.modify do
  factory :supplier, :class => Spree::Supplier do
    sequence(:name) { |i| "Big Store #{i}" }
    email { Faker::Internet.email }
    first_name 'First'
    last_name 'Last'
    url "http://example.com"
    address
  end
end

FactoryGirl.define do
  # Define your Spree extensions Factories within this file to enable applications, and other extensions to use and override them.
  #
  # Example adding this to your spec_helper will load these Factories for use:
  # require 'spree_marketplace/factories'

  factory :supplier_bank_account, class: Spree::SupplierBankAccount do
    supplier
    # Details sent to Balanced.
    name 'John Doe'
    account_number '9900000001'
    routing_number '121000358'
    type 'checking'
  end

end
