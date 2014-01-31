Spree::Core::Engine.add_routes do
  namespace :admin do
    resource :email_invoices_settings, :only => ['update', 'edit']
    
    resources :email_invoices do
      collection do
        post :update_emails
      end
      
      member do
        post :create_order
      end
    end    
  end
end