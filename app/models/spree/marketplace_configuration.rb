module Spree
  class MarketplaceConfiguration < Preferences::Configuration

    # Sets Balanced Payments api configuration.
    preference :balanced_api_key, :string, default: -> {
      if ActiveRecord::Base.connection.table_exists?(:spree_payment_methods)
        # If you are using Balanced Payments as a credit card processor we automatically lookup your api key to use for payments.
        Spree::PaymentMethod.where(type: 'Spree::Gateway::BalancedGateway', environment: Rails.env).first.try(:preferred_login)
      end
    }.call

  end
end