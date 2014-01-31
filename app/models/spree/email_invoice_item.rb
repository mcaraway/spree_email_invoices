class Spree::EmailInvoiceItem < ActiveRecord::Base
  belongs_to :email_invoice
  #attr_accessible :count, :name, :sku  
  
  def extract_sku
    sku.blank? ? "" : sku.sub("-L2", "-2oz").sub("-L4", "-4oz").sub("-L8", "-8oz").sub("-L16", "-1lb")
  end
end
