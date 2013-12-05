class CreateSpreeEmailInvoices < ActiveRecord::Migration
  def change
    create_table :spree_email_invoices do |t|
      t.string :subject
      t.string :from_address
      t.string :message_id
      t.date :message_date
      t.text :body

      t.timestamps
    end
  end
end
