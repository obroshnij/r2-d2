Rails.application.routes.draw do

  devise_for :users
  resources :users

  get 'edit_password' => 'users#edit_password'
  patch 'update_password' => 'users#update_password'
  
  get 'whois' => 'whois#new'
  post 'whois' => 'whois#create'

  get 'alerts' => 'maintenance_alerts#index'

  get 'parse_domains' => 'domain_box#new'
  post 'parse_domains' => 'domain_box#create'
  get 'bulk_dig' => 'domain_box#bulk_dig'
  post 'bulk_dig' => 'domain_box#perform_bulk_dig'
  
  get 'compare' => 'comparator#new'
  post 'compare' => 'comparator#create'

  get 'la_parse' => 'la_tools#new'
  post 'la_parse' => 'la_tools#parse'
  post 'append_csv' => 'la_tools#append_csv'
  get 'cache' => 'la_tools#show_cache'
  get 'dbl_surbl' => 'la_tools#dbl_surbl'
  post 'dbl_surbl' => 'la_tools#dbl_surbl_check'
  get 'cache_dbl_surbl' => 'la_tools#cache_dbl_surbl'

  resources :vip_domains, except: :show
  resources :spammers, only: [:index, :new, :create, :destroy]
  resources :canned_replies

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'whois#new'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
