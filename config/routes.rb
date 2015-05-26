Rails.application.routes.draw do
  
  # get '(*path)', to: 'domain_box#unauthorized', constraints: lambda { |request| Rails.env == "production" && !WhitelistedAddress.find_by(value: request.remote_ip) }

  devise_for :users
  resources :users

  get 'change_password' => 'users#edit_password'
  patch 'update_password' => 'users#update_password'
  
  get 'alerts' => 'maintenance_alerts#index'

  get 'whois' => 'domain_box#whois'
  post 'whois' => 'domain_box#whois_lookup'
  get 'parse_domains' => 'domain_box#parse_domains'
  post 'parse_domains' => 'domain_box#perform_parsing'
  get 'bulk_dig' => 'domain_box#bulk_dig'
  post 'bulk_dig' => 'domain_box#perform_bulk_dig'
  get 'compare' => 'domain_box#compare_lists'
  post 'compare' => 'domain_box#perform_comparison'

  get 'spam' => 'la_tools#new'
  post 'spam' => 'la_tools#parse'
  post 'append_csv' => 'la_tools#append_csv'
  get 'spam_result' => 'la_tools#spam_result'
  get 'dbl_surbl' => 'la_tools#dbl_surbl'
  post 'dbl_surbl' => 'la_tools#dbl_surbl_check'
  get 'bulk_curl' => 'la_tools#bulk_curl'
  post 'bulk_curl' => 'la_tools#perform_bulk_curl'
  
  get 'monthly_reports' => 'manager_tools#monthly_reports'
  post 'monthly_reports' => 'manager_tools#generate_monthly_reports'

  resources :vip_domains, except: :show
  resources :spammers, only: [:index, :new, :create, :destroy]
  resources :internal_accounts, only: [:index, :new, :create, :destroy]
  # resources :canned_replies

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'domain_box#whois'

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
