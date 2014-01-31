class CreateSpreeEmailInvoices < ActiveRecord::Migration
  def change
    create_table :spree_email_invoices do |t|
      t.string :order_number
      t.string :shipping_state
      t.string :tracking_number
      t.string :customer
      t.string :shipping_method
      t.string :subject
      t.string :from_address
      t.date :message_date
      t.string :company
      t.string :address
      t.string :city
      t.string :state
      t.string :zip
      t.string :phone
      t.string :email
      t.text :body

      t.timestamps
    end
  end
end
