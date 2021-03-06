Myapp::Application.routes.draw do

  resources :users
  resources :items
  resources :admin
  get "users/new"
  post "users/login"
  post "admin/new"
  #post "admin/help"
  get "log_out" => "users#logout", :as => "log_out"
  get "help" => "admin#help", :as => "help"
  post "users/view_user"
  post "items/view_stock"
  post "items/cart_item"
  post "items/new_sale"
  post "items/transact"
  post "admin/read_log"
  #delete 'destroy' => 'items#destroy'

  get "items/autocomplete"

  #get 'users/autocomplete_brand_name'
  #get 'items/autocomplete_brand_name', :on => :collection



   resources :items, only: :index do
    collection do
      post :import

      #get :autocomplete # <= add this line
    end
  end
  
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'users#index'

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
