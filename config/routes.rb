Spree::Core::Engine.add_routes do
  namespace :admin do
    resources :email_invoices do
      collection do
        post :test_emails
      end
    end    
  end
end