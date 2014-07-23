require 'spec_helper'
require 'cancan/matchers'
require 'spree/testing_support/ability_helpers'

describe Spree::SupplierAbility do

  let(:user) { create(:user, supplier: create(:supplier)) }
  let(:ability) { Spree::SupplierAbility.new(user) }
  let(:token) { nil }

  context 'for Dash' do
    let(:resource) { Spree::Admin::OverviewController }

    context 'requested by supplier' do
      it_should_behave_like 'access denied'
      it_should_behave_like 'no index allowed'
      it_should_behave_like 'admin denied'
    end
  end

  context 'for Digital' do
    let(:resource) { Spree::Digital }

    it_should_behave_like 'index allowed'
    it_should_behave_like 'admin granted'

    context 'requested by another suppliers user' do
      let(:resource) {
        p = create :product
        p.add_supplier! create(:supplier)
        Spree::Digital.new(variant: p.reload.master)
      }
      it_should_behave_like 'create only'
    end

    context 'requested by suppliers user' do
      let(:resource) {
        p = create :product
        p.add_supplier! user.supplier
        Spree::Digital.new(variant: p.reload.master)
      }
      it_should_behave_like 'access granted'
    end
  end

  context 'for Image' do
    let(:resource) { Spree::Image }

    it_should_behave_like 'index allowed'
    it_should_behave_like 'admin granted'

    context 'requested by another suppliers user' do
      let(:variant) {
        p = create :product
        p.add_supplier! create(:supplier)
        p.master
      }
      let(:resource) { Spree::Image.new({viewable_id: variant.id, viewable_type: variant.class.to_s}, without_protection: true) }
      it_should_behave_like 'create only'
    end

    context 'requested by suppliers user' do
      let(:variant) {
        p = create :product
        p.add_supplier! user.supplier
        p.master
      }
      let(:resource) { Spree::Image.new({viewable_id: variant.id, viewable_type: variant.class.to_s}, without_protection: true) }
      it_should_behave_like 'access granted'
    end
  end

  context 'for GroupPricing' do
    let(:resource) { Spree::GroupPrice }

    context 'requested by another suppliers user' do
      let(:resource) {
        p = create :product
        p.add_supplier! create(:supplier)
        Spree::GroupPrice.new(variant: p.reload.master)
      }
      it_should_behave_like 'access denied'
    end

    context 'requested by suppliers user' do
      let(:resource) {
        p = create :product
        p.add_supplier! user.supplier
        Spree::GroupPrice.new(variant: p.reload.master)
      }
      it_should_behave_like 'access granted'
    end
  end

  context 'for Product' do
    let(:resource) { Spree::Product }

    it_should_behave_like 'index allowed'
    it_should_behave_like 'admin granted'

    context 'requested by another suppliers user' do
      let(:resource) {
        p = create :product
        p.add_supplier! create(:supplier)
        p
      }
      it { ability.should be_able_to :create, resource }
    end

    context 'requested by suppliers user' do
      let(:resource) {
        p = create :product
        p.add_supplier! user.supplier
        p.reload
      }
      it_should_behave_like 'access granted'
    end
  end

  context 'for ProductProperty' do
    let(:resource) { Spree::ProductProperty }

    it_should_behave_like 'index allowed'
    it_should_behave_like 'admin granted'

    context 'requested by another suppliers user' do
      let(:resource) {
        p = create :product
        p.add_supplier! create(:supplier)
        Spree::ProductProperty.new(product: p.reload)
      }
      it_should_behave_like 'access denied'
    end

    context 'requested by suppliers user' do
      let(:resource) {
        p = create :product
        p.add_supplier! user.supplier
        Spree::ProductProperty.new(product: p.reload)
      }
      it_should_behave_like 'access granted'
    end
  end

  context 'for Property' do
    let(:resource) { Spree::Property }

    it_should_behave_like 'admin granted'
    it_should_behave_like 'read only'
  end

  context 'for Prototype' do
    let(:resource) { Spree::Prototype }

    it_should_behave_like 'admin granted'
    it_should_behave_like 'read only'
  end

  context 'for Relation' do
    let(:resource) { Spree::Relation }

    it_should_behave_like 'index allowed'
    it_should_behave_like 'admin granted'

    context 'requested by another suppliers user' do
      let(:resource) {
        p = create :product
        p.add_supplier! create(:supplier)
        Spree::Relation.new(relatable: p.reload)
      }
      it_should_behave_like 'access denied'
    end

    context 'requested by suppliers user' do
      let(:resource) {
        p = create :product
        p.add_supplier! user.supplier
        Spree::Relation.new(relatable: p.reload)
      }
      it_should_behave_like 'access granted'
    end
  end

  context 'for Shipment' do
    context 'requested by another suppliers user' do
      let(:resource) { Spree::Shipment.new({stock_location: create(:stock_location, supplier: create(:supplier))}, without_protection: true) }
      it_should_behave_like 'access denied'
      it_should_behave_like 'no index allowed'
      it_should_behave_like 'admin denied'
      it { ability.should_not be_able_to :ready, resource }
      it { ability.should_not be_able_to :ship, resource }
    end

    context 'requested by suppliers user' do
      context 'when order is complete' do
        let(:resource) {
          order = create(:completed_order_for_drop_ship_with_totals)
          order.stock_locations.first.update_attribute :supplier, user.supplier
          Spree::Shipment.new({order: order, stock_location: order.stock_locations.first }, without_protection: true)
        }
        it_should_behave_like 'access granted'
        it_should_behave_like 'index allowed'
        it_should_behave_like 'admin granted'
        it { ability.should be_able_to :ready, resource }
        it { ability.should be_able_to :ship, resource }
      end

      context 'when order is incomplete' do
        let(:resource) { Spree::Shipment.new({stock_location: create(:stock_location, supplier: user.supplier)}, without_protection: true) }
        it_should_behave_like 'access denied'
        it { ability.should_not be_able_to :ready, resource }
        it { ability.should_not be_able_to :ship, resource }
      end
    end
  end

  context 'for StockItem' do
    let(:resource) { Spree::StockItem }

    it_should_behave_like 'index allowed'
    it_should_behave_like 'admin granted'

    context 'requested by another suppliers user' do
      let(:resource) {
        p = create :product
        supplier = create(:supplier)
        p.add_supplier! supplier
        Spree::StockItem.new(stock_location_id: supplier.stock_locations.first.id)
      }
      it_should_behave_like 'access denied'
    end

    context 'requested by suppliers user' do
      let(:resource) {
        p = create :product
        p.add_supplier! user.supplier
        Spree::StockItem.new(stock_location_id: user.supplier.stock_locations.first.id)
      }
      it_should_behave_like 'access granted'
    end
  end

  context 'for StockLocation' do
    context 'requsted by another suppliers user' do
      let(:resource) { Spree::StockLocation.new({supplier: create(:supplier)}, without_protection: true) }
      it_should_behave_like 'create only'
    end

    context 'requested by suppliers user' do
      let(:resource) { Spree::StockLocation.new({supplier: user.supplier}, without_protection: true) }
      it_should_behave_like 'access granted'
      it_should_behave_like 'admin granted'
      it_should_behave_like 'index allowed'
    end
  end

  context 'for StockMovement' do
    let(:resource) { Spree::StockMovement }

    it_should_behave_like 'index allowed'
    it_should_behave_like 'admin granted'

    context 'requested by another suppliers user' do
      let(:resource) {
        p = create :product
        supplier = create(:supplier)
        p.add_supplier! supplier
        Spree::StockMovement.new stock_item: p.master.stock_items.where(stock_location_id: supplier.stock_locations.pluck(:id)).first
      }
      it_should_behave_like 'create only'
    end

    context 'requested by suppliers user' do
      let(:resource) {
        p = create :product
        p.add_supplier! user.supplier
        Spree::StockMovement.new stock_item: p.master.stock_items.where(stock_location_id: user.supplier.stock_locations.pluck(:id)).first
      }
      it_should_behave_like 'access granted'
    end
  end

  context 'for Supplier' do
    context 'requested by any user' do
      let(:ability) { Spree::SupplierAbility.new(create(:user)) }
      let(:resource) { Spree::Supplier }

      it_should_behave_like 'admin denied'

      context 'w/ Marketplace Config[:allow_signup] == false (the default)' do
        it_should_behave_like 'access denied'
      end

      context 'w/ Marketplace Config[:allow_signup] == true' do
        after do
          SpreeMarketplace::Config.set allow_signup: false
        end
        before do
          SpreeMarketplace::Config.set allow_signup: true
        end
        it_should_behave_like 'create only'
      end
    end

    context 'requested by suppliers user' do
      let(:resource) { user.supplier }
      it_should_behave_like 'admin granted'
      it_should_behave_like 'update only'
    end
  end

  context 'for Variant' do
    let(:resource) { Spree::Variant }

    it_should_behave_like 'index allowed'
    it_should_behave_like 'admin granted'

    context 'requested by another suppliers user' do
      let(:resource) {
        p = create :product
        p.add_supplier! create(:supplier)
        p.reload.master
      }
      it_should_behave_like 'access denied'
    end

    context 'requested by suppliers user' do
      let(:resource) {
        p = create :product
        p.add_supplier! user.supplier
        p.reload.master
      }
      it_should_behave_like 'access granted'
    end
  end

end
