class Spree::Admin::SupplierBankAccountsController < Spree::Admin::ResourceController

  before_filter :load_supplier
  create.before :set_supplier

  def new
    @object = @supplier.bank_accounts.build
  end

  private

    def load_supplier
      @supplier = Spree::Supplier.friendly.find(params[:supplier_id])
    end

    def location_after_save
      spree.edit_admin_supplier_path(@supplier)
    end

    def set_supplier
      @object.supplier = @supplier
    end

end
