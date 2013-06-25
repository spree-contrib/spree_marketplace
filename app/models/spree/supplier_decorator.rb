Spree::Supplier.class_eval do

  has_many   :bank_accounts, class_name: 'Spree::SupplierBankAccount'

  before_create :set_token

  private

  def set_token
    Balanced.configure(SpreeMarketplace::Config[:balanced_api_key])
    marketplace = Balanced::Marketplace.my_marketplace
    account     = Balanced::Marketplace.my_marketplace.create_account
    self.token  = account.uri
    if self.merchant_type == 'individual'
      merchant_data = {
        :dob => self.contacts_date_of_birth.strftime('%Y-%m-%d'),
        :name => self.address.full_name,
        :phone_number => self.address.phone,
        :postal_code => self.address.zipcode,
        :street_address => self.address.address1,
        :type => 'person'
      }
    elsif self.merchant_type == 'business'
      merchant_data = {
        :name => self.name,
        :phone_number => self.address.phone,
        :postal_code => self.address.zipcode,
        :street_address => self.address.address1,
        :tax_id => self.tax_id,
        :type => 'business',
        :person => {
          :dob => self.contacts_date_of_birth.strftime('%Y-%m-%d'),
          :phone_number => self.address.phone,
          :postal_code => self.address.zipcode,
          :name => self.address.full_name,
          :street_address => self.address.address1,
        },
      }
    end
    account.promote_to_merchant(merchant_data)
  end

end
