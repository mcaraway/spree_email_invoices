require 'spec_helper'

describe "spree/email_invoices/index" do
  before(:each) do
    assign(:spree_email_invoices, [
      stub_model(Spree::EmailInvoice,
        :subject => "Subject"
      ),
      stub_model(Spree::EmailInvoice,
        :subject => "Subject"
      )
    ])
  end

  it "renders a list of spree/email_invoices" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Subject".to_s, :count => 2
  end
end
