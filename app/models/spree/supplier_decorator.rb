Spree::Supplier.class_eval do

  has_many   :bank_accounts, class_name: 'Spree::SupplierBankAccount'

  before_create :balanced_customer_setup
  before_save :balanced_customer_update

  private

  def balanced_customer_setup
    Balanced.configure(SpreeMarketplace::Config[:balanced_api_key])

    merchant_data = {
      :name => self.name,
      :email => self.email,
      :business_name => self.name,
      :ein => self.tax_id
    }
    customer = Balanced::Marketplace.mine.create_customer merchant_data
    self.token = customer.uri
  end

  def balanced_customer_update
    unless new_record? or !changed?
      Balanced.configure(SpreeMarketplace::Config[:balanced_api_key])
      customer = Balanced::Customer.find(self.token)
      customer.attributes['name'] = self.name
      customer.attributes['email'] = self.email
      customer.attributes['business_name'] = self.name
      customer.attributes['ein'] = self.tax_id
      customer.attributes['phone'] = self.address.try(:phone)
      customer.attributes['address']['line1'] = self.address.try(:address1)
      customer.attributes['address']['line2'] = self.address.try(:address2)
      customer.attributes['address']['city'] = self.address.try(:city)
      customer.attributes['address']['state'] = (self.address.state ? self.address.state.name : nil)
      customer.attributes['address']['postal_code'] = self.address.try(:zipcode)
      customer.attributes['address']['country_code'] = (self.address.country ? self.address.country.iso : nil)
      customer.save
    end
    return true # always return true so AR saving continues even if customer.save fails.
  end
end
