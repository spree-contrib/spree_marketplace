Spree::Admin::ProductsController.class_eval do

  create.after :set_supplier

  private

    def set_supplier
      if try_spree_current_user.supplier?
        @object.add_supplier! spree_current_user.supplier
      end
    end

    # def collection
    #   return parent.send(controller_name) if parent_data.present?
    #   if model_class.respond_to?(:accessible_by) && !current_ability.has_block?(params[:action], model_class)
    #     model_class.accessible_by(current_ability, action)
    #   else
    #     model_class.scoped
    #   end
    # end

    # def collection
    #   return @collection if @collection.present?
    #   params[:q] ||= {}
    #   params[:q][:deleted_at_null] ||= "1"
    #
    #   params[:q][:s] ||= "name asc"
    #   @collection = super
    #   # @collection = @collection.with_deleted if params[:q][:deleted_at_null] == '0'
    #   # @search needs to be defined as this is passed to search_form_for
    #   @search = @collection.ransack(params[:q])
    #   @collection = @search.result.
    #         distinct_by_product_ids(params[:q][:s]).
    #         includes(product_includes).
    #         page(params[:page]).
    #         per(Spree::Config[:admin_products_per_page])
    #
    #   @collection
    # end

end
