require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe Spree::EmailInvoicesController do

  # This should return the minimal set of attributes required to create a valid
  # Spree::EmailInvoice. As you add validations to Spree::EmailInvoice, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) { { "subject" => "MyString" } }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # Spree::EmailInvoicesController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET index" do
    it "assigns all spree_email_invoices as @spree_email_invoices" do
      email_invoice = Spree::EmailInvoice.create! valid_attributes
      get :index, {}, valid_session
      assigns(:spree_email_invoices).should eq([email_invoice])
    end
  end

  describe "GET show" do
    it "assigns the requested spree_email_invoice as @spree_email_invoice" do
      email_invoice = Spree::EmailInvoice.create! valid_attributes
      get :show, {:id => email_invoice.to_param}, valid_session
      assigns(:spree_email_invoice).should eq(email_invoice)
    end
  end

  describe "GET new" do
    it "assigns a new spree_email_invoice as @spree_email_invoice" do
      get :new, {}, valid_session
      assigns(:spree_email_invoice).should be_a_new(Spree::EmailInvoice)
    end
  end

  describe "GET edit" do
    it "assigns the requested spree_email_invoice as @spree_email_invoice" do
      email_invoice = Spree::EmailInvoice.create! valid_attributes
      get :edit, {:id => email_invoice.to_param}, valid_session
      assigns(:spree_email_invoice).should eq(email_invoice)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Spree::EmailInvoice" do
        expect {
          post :create, {:spree_email_invoice => valid_attributes}, valid_session
        }.to change(Spree::EmailInvoice, :count).by(1)
      end

      it "assigns a newly created spree_email_invoice as @spree_email_invoice" do
        post :create, {:spree_email_invoice => valid_attributes}, valid_session
        assigns(:spree_email_invoice).should be_a(Spree::EmailInvoice)
        assigns(:spree_email_invoice).should be_persisted
      end

      it "redirects to the created spree_email_invoice" do
        post :create, {:spree_email_invoice => valid_attributes}, valid_session
        response.should redirect_to(Spree::EmailInvoice.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved spree_email_invoice as @spree_email_invoice" do
        # Trigger the behavior that occurs when invalid params are submitted
        Spree::EmailInvoice.any_instance.stub(:save).and_return(false)
        post :create, {:spree_email_invoice => { "subject" => "invalid value" }}, valid_session
        assigns(:spree_email_invoice).should be_a_new(Spree::EmailInvoice)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Spree::EmailInvoice.any_instance.stub(:save).and_return(false)
        post :create, {:spree_email_invoice => { "subject" => "invalid value" }}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested spree_email_invoice" do
        email_invoice = Spree::EmailInvoice.create! valid_attributes
        # Assuming there are no other spree_email_invoices in the database, this
        # specifies that the Spree::EmailInvoice created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Spree::EmailInvoice.any_instance.should_receive(:update).with({ "subject" => "MyString" })
        put :update, {:id => email_invoice.to_param, :spree_email_invoice => { "subject" => "MyString" }}, valid_session
      end

      it "assigns the requested spree_email_invoice as @spree_email_invoice" do
        email_invoice = Spree::EmailInvoice.create! valid_attributes
        put :update, {:id => email_invoice.to_param, :spree_email_invoice => valid_attributes}, valid_session
        assigns(:spree_email_invoice).should eq(email_invoice)
      end

      it "redirects to the spree_email_invoice" do
        email_invoice = Spree::EmailInvoice.create! valid_attributes
        put :update, {:id => email_invoice.to_param, :spree_email_invoice => valid_attributes}, valid_session
        response.should redirect_to(email_invoice)
      end
    end

    describe "with invalid params" do
      it "assigns the spree_email_invoice as @spree_email_invoice" do
        email_invoice = Spree::EmailInvoice.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Spree::EmailInvoice.any_instance.stub(:save).and_return(false)
        put :update, {:id => email_invoice.to_param, :spree_email_invoice => { "subject" => "invalid value" }}, valid_session
        assigns(:spree_email_invoice).should eq(email_invoice)
      end

      it "re-renders the 'edit' template" do
        email_invoice = Spree::EmailInvoice.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Spree::EmailInvoice.any_instance.stub(:save).and_return(false)
        put :update, {:id => email_invoice.to_param, :spree_email_invoice => { "subject" => "invalid value" }}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested spree_email_invoice" do
      email_invoice = Spree::EmailInvoice.create! valid_attributes
      expect {
        delete :destroy, {:id => email_invoice.to_param}, valid_session
      }.to change(Spree::EmailInvoice, :count).by(-1)
    end

    it "redirects to the spree_email_invoices list" do
      email_invoice = Spree::EmailInvoice.create! valid_attributes
      delete :destroy, {:id => email_invoice.to_param}, valid_session
      response.should redirect_to(spree_email_invoices_url)
    end
  end

end
