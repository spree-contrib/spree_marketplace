Spree::Supplier.class_eval do

  has_many :bank_accounts, class_name: 'Spree::SupplierBankAccount'

  # TODO move to spree_marketplace? not really used anywhere in here
  validates :tax_id,                 length: { is: 9, allow_blank: true }

  before_create :stripe_recipient_setup
  before_save :stripe_recipient_update

  private

  def stripe_recipient_setup
    return if self.tax_id.blank? and self.address.blank?

    recipient = Stripe::Recipient.create(
      :name => (self.tax_id.present? ? self.name : self.address.first_name + ' ' + self.address.last_name),
      :type => (self.tax_id.present? ? 'corporation' : "individual"),
      :email => self.email,
      :bank_account => self.bank_accounts.first.try(:token)
    )

    if new_record?
      self.token = recipient.id
    else
      self.update_column :token, recipient.id
    end
  end

  def stripe_recipient_update
    unless new_record? or !changed?
      if token.present?
        rp = Stripe::Recipient.retrieve(token)
        rp.name  = name
        rp.email = email
        if tax_id.present?
          rp.tax_id = tax_id
          rp.type   = 'corporation'
        end
        rp.bank_account = bank_accounts.first.token if bank_accounts.first
        rp.save
      else
        stripe_recipient_setup
      end
    end
  end

end
