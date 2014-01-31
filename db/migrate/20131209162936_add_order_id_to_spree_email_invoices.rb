class AddOrderIdToSpreeEmailInvoices < ActiveRecord::Migration
  def change
    add_column :spree_email_invoices, :order_id, :integer
  end
end
