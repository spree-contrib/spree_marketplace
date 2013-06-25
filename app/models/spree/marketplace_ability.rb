module Spree
  class MarketplaceAbility
    include CanCan::Ability

    def initialize(user)
      user ||= Spree.user_class.new

      if user.supplier
        can [:admin, :manage], Spree::SupplierBankAccount, supplier_id: user.supplier_id
        can :create, Spree::SupplierBankAccount
      end
    end
  end
end
