class Spree::Admin::MarketplaceSettingsController < Spree::Admin::BaseController

  def edit
    @config = Spree::MarketplaceConfiguration.new
  end

  def update
    config = Spree::MarketplaceConfiguration.new

    params.each do |name, value|
      next unless config.has_preference? name
      config[name] = value
    end

    flash[:success] = Spree.t('admin.marketplace_settings.update.success')
    redirect_to spree.edit_admin_marketplace_settings_path
  end

end
