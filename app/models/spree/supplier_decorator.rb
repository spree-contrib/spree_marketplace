Spree::Supplier.class_eval do

  has_many   :bank_accounts, class_name: 'Spree::SupplierBankAccount'

  before_create :balanced_customer_setup
  before_save :balanced_customer_update

  private

  def balanced_customer_setup
    Balanced.configure(SpreeMarketplace::Config[:balanced_api_key])

    merchant_data = if self.tax_id.present?
      {
        :email => self.email,
        :name => self.name,
        :business_name => self.name,
        :ein => self.tax_id
      }
    else
      {
        :email => self.email,
        :name => self.name
      }
    end

    customer = Balanced::Customer.new(merchant_data).save
    self.token = customer.uri
  end

  def balanced_customer_update
    unless new_record? or !changed?
      Balanced.configure(SpreeMarketplace::Config[:balanced_api_key])
      customer = Balanced::Customer.find(self.token)
      customer.attributes['name'] = self.name
      customer.attributes['email'] = self.email
      if self.tax_id.present?
        customer.attributes['business_name'] = self.name
        customer.attributes['ein'] = self.tax_id
      end
      if self.address.present?
        customer.attributes['phone'] = self.address.phone
        customer.attributes['address']['line1'] = self.address.address1
        customer.attributes['address']['line2'] = self.address.address2
        customer.attributes['address']['city'] = self.address.city
        customer.attributes['address']['state'] = (self.address.state ? self.address.state.name : nil)
        customer.attributes['address']['postal_code'] = self.address.zipcode
        customer.attributes['address']['country_code'] = (self.address.country ? self.address.country.iso : nil)
      end
      customer.save
    end
  rescue Balanced::BadRequest
    return true # always return true so AR saving continues even if customer.save fails.
  end
end
