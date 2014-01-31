class Spree::EmailInvoicesConfiguration < Spree::Preferences::Configuration
    
  preference :pop_server, :string, :default => "pop.uniqteas.com"
  preference :pop_port, :integer, :default => 995
  preference :pop_enable_ssl, :boolean, :default => true
  preference :pop_user_email_address, :string, :default => "orders@uniqteas.com"
  preference :pop_user_password, :string, :default => "B4radhur"
  preference :pop_retrieve_email_count, :integer, :default => 20
  preference :from_email_address, :string, :default => "sales@coffeeforless.com"
  preference :user_email_address, :string, :default => "brian@coffeeforless.com"
end
