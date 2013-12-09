Spree::Supplier.class_eval do

  has_many   :bank_accounts, class_name: 'Spree::SupplierBankAccount'

  # before_create :stripe_recipient_setup

  private

  # TODO do we actually need bank account first or can we just update later?
  def stripe_recipient_setup
    Stripe.api_key = SpreeMarketplace::Config[:stripe_secret_key]

    recipient = Stripe::Recipient.create(
      :name => self.name,
      :type => (self.tax_id.present? ? 'business' : "individual"),
      :email => self.email,
      :bank_account => bank_accounts.first.token
    )
    Rails.logger.debug "RECIPIENT: #{recipient.inspect}"
    self.token = recipient.id
  end

end
