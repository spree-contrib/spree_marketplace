module Spree
  class SupplierAbility
    include CanCan::Ability

    def initialize(user)
      user ||= Spree.user_class.new

      if user.supplier
        if SpreeMarketplace::Engine.spree_digital_available?
          # can [:admin, :manage], Spree::Digital, variant: { supplier_ids: user.supplier_id }
          can [:admin, :manage], Spree::Digital do |digital|
            digital.variant.supplier_ids.include?(user.supplier_id)
          end
          can :create, Spree::Digital
        end
        can [:admin, :manage], Spree::Image do |image|
          image.viewable.product.supplier_ids.include?(user.supplier_id)
        end
        can :create, Spree::Image
        if SpreeMarketplace::Engine.spree_group_price_available?
          # can [:admin, :manage], Spree::GroupPrice, variant: { supplier_ids: user.supplier_id }
          can [:admin, :manage], Spree::GroupPrice do |price|
            price.variant.supplier_ids.include?(user.supplier_id)
          end
        end
        if SpreeMarketplace::Engine.spree_related_products_available?
          # can [:admin, :manage], Spree::Relation, relatable: { supplier_ids: user.supplier_id }
          can [:admin, :manage], Spree::Relation do |relation|
            relation.relatable.supplier_ids.include?(user.supplier_id)
          end
        end
        # TODO: Want this to be inline like:
        # can [:admin, :manage, :stock], Spree::Product, suppliers: { id: user.supplier_id }
        can [:admin, :manage, :stock], Spree::Product do |product|
          product.supplier_ids.include?(user.supplier_id)
        end
        can [:admin, :create, :index], Spree::Product
        # can [:admin, :manage], Spree::ProductProperty, product: { supplier_ids: user.supplier_id }
        can [:admin, :manage, :stock], Spree::ProductProperty do |property|
          property.product.supplier_ids.include?(user.supplier_id)
        end
        can [:admin, :index, :read], Spree::Property
        can [:admin, :read], Spree::Prototype
        can [:admin, :manage, :read, :ready, :ship], Spree::Shipment, order: { state: 'complete' }, stock_location: { supplier_id: user.supplier_id }
        can [:admin, :create, :update], :stock_items
        can [:admin, :manage], Spree::StockItem, stock_location_id: user.supplier.stock_locations.pluck(:id)
        can [:admin, :manage], Spree::StockLocation, supplier_id: user.supplier_id
        can :create, Spree::StockLocation
        can [:admin, :manage], Spree::StockMovement, stock_item: { stock_location_id: user.supplier.stock_locations.pluck(:id) }
        can :create, Spree::StockMovement
        can [:admin, :update], Spree::Supplier, id: user.supplier_id
        # TODO: Want this to be inline like:
        # can [:admin, :manage], Spree::Variant, supplier_ids: user.supplier_id
        can [:admin, :manage], Spree::Variant do |variant|
          variant.supplier_ids.include?(user.supplier_id)
        end
      end

      if SpreeMarketplace::Config[:allow_signup]
        can :create, Spree::Supplier
      end

      if SpreeMarketplace::Engine.ckeditor_available?
        can :access, :ckeditor

        can :create, Ckeditor::AttachmentFile
        can [:read, :index, :destroy], Ckeditor::AttachmentFile, supplier_id: user.supplier_id

        can :create, Ckeditor::Picture
        can [:read, :index, :destroy], Ckeditor::Picture, supplier_id: user.supplier_id
      end
    end

  end
end
