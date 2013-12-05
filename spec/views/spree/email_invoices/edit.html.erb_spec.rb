require 'spec_helper'

describe "spree/email_invoices/edit" do
  before(:each) do
    @spree_email_invoice = assign(:spree_email_invoice, stub_model(Spree::EmailInvoice,
      :subject => "MyString"
    ))
  end

  it "renders the edit spree_email_invoice form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", spree_email_invoice_path(@spree_email_invoice), "post" do
      assert_select "input#spree_email_invoice_subject[name=?]", "spree_email_invoice[subject]"
    end
  end
end
