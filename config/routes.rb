ActionController::Routing::Routes.draw do |map|
  map.root      :controller => 'welcome',
                :action => 'index'
  map.resources :accounts do |account|
    account.resources :rules, :except => [:show]
  end
  map.resources :imports,
                :only => [:index, :new, :create]
  map.resources :matches,
                :only => [:show, :destroy]
  map.resources :mappings,
                :except => [:show]
  map.resources :ledger_items,
                :as => 'transactions',
                :new => { :multiple => [:get, :post] }
  map.resources :contacts,
                :has_many => :ledger_items
  map.resources :reports,
                :only => :show
  map.resource  :user_session,
                :as => 'session',
                :only => [:new, :create, :destroy]
  map.logout    '/logout',
                :controller => 'user_sessions',
                :action => 'destroy'
  
  map.add_to_cart '/add_to_cart', :controller => 'ledger_items', :action => 'add_to_cart'
  map.balance_cart '/balance_cart', :controller => 'ledger_items', :action => 'balance_cart'
  map.save_cart '/save_cart', :controller => 'ledger_items', :action => 'save_cart'
  map.empty_cart '/empty_cart', :controller => 'ledger_items', :action => 'empty_cart'
end
