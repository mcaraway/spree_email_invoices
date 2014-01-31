class CreateSpreeEmailInvoiceItems < ActiveRecord::Migration
  def change
    create_table :spree_email_invoice_items do |t|
      t.string :sku
      t.string :name
      t.integer :count
      t.integer :email_invoice_id

      t.timestamps
    end
  end
end
