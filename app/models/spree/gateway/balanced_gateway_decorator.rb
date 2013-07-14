if defined?(Spree::Gateway::BalancedGateway)
  module Spree
    Gateway::BalancedGateway.class_eval do
      def capture(authorization, creditcard, gateway_options)
        puts 'BALANCEDCAPTURE in spree_market'
        puts authorization.inspect
        puts (authorization.amount * 100).round
        puts authorization.shipment.inspect
        puts authorization.shipment.supplier.token if authorization.shipment and authorization.shipment.supplier.present?
        puts self.preferred_on_behalf_of_uri
        if authorization.shipment and authorization.shipment.supplier.present?
          gateway_options[:on_behalf_of_uri] = authorization.shipment.supplier.token
        else
          gateway_options[:on_behalf_of_uri] = self.preferred_on_behalf_of_uri
        end
        puts gateway_options[:on_behalf_of_uri]
        provider.capture((authorization.amount * 100).round, authorization.response_code, gateway_options)
      end
    end
  end
end
