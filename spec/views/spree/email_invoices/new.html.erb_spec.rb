require 'spec_helper'

describe "spree/email_invoices/new" do
  before(:each) do
    assign(:spree_email_invoice, stub_model(Spree::EmailInvoice,
      :subject => "MyString"
    ).as_new_record)
  end

  it "renders new spree_email_invoice form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", spree_email_invoices_path, "post" do
      assert_select "input#spree_email_invoice_subject[name=?]", "spree_email_invoice[subject]"
    end
  end
end
