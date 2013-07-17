if defined?(Spree::Gateway::BalancedGateway)
  module Spree
    Gateway::BalancedGateway.class_eval do
      def capture(authorization, creditcard, gateway_options)
        if authorization.drop_ship_order and authorization.drop_ship_order.supplier.present?
          gateway_options[:on_behalf_of_uri] = authorization.drop_ship_order.supplier.token
        else
          gateway_options[:on_behalf_of_uri] = self.preferred_on_behalf_of_uri
        end
        provider.capture((authorization.amount * 100).round, authorization.response_code, gateway_options)
      end
    end
  end
end
