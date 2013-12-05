require 'spec_helper'

describe "spree/email_invoices/show" do
  before(:each) do
    @spree_email_invoice = assign(:spree_email_invoice, stub_model(Spree::EmailInvoice,
      :subject => "Subject"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Subject/)
  end
end
