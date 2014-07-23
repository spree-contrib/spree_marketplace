module Spree
  class MarketplaceConfiguration < Preferences::Configuration

    # Allow users to signup as a supplier.
    preference :allow_signup, :boolean, default: false

    # Sets Stripe api configuration.
    preference :stripe_publishable_key, :string, default: -> {
      if ActiveRecord::Base.connection.table_exists?(:spree_payment_methods)
        # If you are using Stripe as a credit card processor we automatically lookup your api key to use for payments.
        Spree::PaymentMethod.where(type: 'Spree::Gateway::StripeGateway', environment: Rails.env).first.try(:preferred_publishable_key)
      else
        nil
      end
    }.call

    preference :stripe_secret_key, :string, default: -> {
      if ActiveRecord::Base.connection.table_exists?(:spree_payment_methods)
        # If you are using Stripe as a credit card processor we automatically lookup your api key to use for payments.
        Spree::PaymentMethod.where(type: 'Spree::Gateway::StripeGateway', environment: Rails.env).first.try(:preferred_secret_key)
      else
        nil
      end
    }.call

  end
end
