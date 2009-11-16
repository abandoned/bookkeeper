ActionController::Routing::Routes.draw do |map|
  map.resources :accounts, :has_many => [:rules, :ledger_items]
  map.resource  :import, :only => [:new, :create]
  map.resources :matches, :except => [:index]
  map.resources :mappings, :ledger_items
  map.resources :people, :has_many => :ledger_items
  map.resource :user_session, :only => [:new, :create, :destroy]
  
  map.logout  "/logout",  :controller => "user_sessions", :action => "destroy"
  
  map.add_to_cart "/add_to_cart", :controller => "ledger_items", :action => "add_to_cart"
  map.balance_cart "/balance_cart", :controller => "ledger_items", :action => "balance_cart"
  map.save_cart "/save_cart", :controller => "ledger_items", :action => "save_cart"
  map.empty_cart "/empty_cart", :controller => "ledger_items", :action => "empty_cart"
  
  map.root :controller => "welcome", :action => "index"

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_path(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing or commenting them out if you're using named routes and resources.
end
