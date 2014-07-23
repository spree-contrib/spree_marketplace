Spree::Core::Engine.routes.draw do
  namespace :admin do
    resource :marketplace_settings
    resources :suppliers do
      resources :bank_accounts, controller: 'supplier_bank_accounts'
    end
  end
  resources :suppliers, only: [:create, :new]
end
