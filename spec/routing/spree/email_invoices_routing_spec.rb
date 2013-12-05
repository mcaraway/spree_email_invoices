require "spec_helper"

describe Spree::EmailInvoicesController do
  describe "routing" do

    it "routes to #index" do
      get("/spree/email_invoices").should route_to("spree/email_invoices#index")
    end

    it "routes to #new" do
      get("/spree/email_invoices/new").should route_to("spree/email_invoices#new")
    end

    it "routes to #show" do
      get("/spree/email_invoices/1").should route_to("spree/email_invoices#show", :id => "1")
    end

    it "routes to #edit" do
      get("/spree/email_invoices/1/edit").should route_to("spree/email_invoices#edit", :id => "1")
    end

    it "routes to #create" do
      post("/spree/email_invoices").should route_to("spree/email_invoices#create")
    end

    it "routes to #update" do
      put("/spree/email_invoices/1").should route_to("spree/email_invoices#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/spree/email_invoices/1").should route_to("spree/email_invoices#destroy", :id => "1")
    end

  end
end
