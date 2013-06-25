Spree::Core::Engine.routes.draw do
  namespace :admin do
    resources :suppliers do
      resources :bank_accounts, controller: 'supplier_bank_accounts'
    end
  end
end
