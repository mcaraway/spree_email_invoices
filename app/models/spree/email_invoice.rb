class Spree::EmailInvoice < ActiveRecord::Base
  
  attr_accessible :order_number, :customer 
  def extract_invoice_info 
    order_number = subject.partition("#").last
    customer = body.match("(?<=Name: )(.*\n?)(?=<br>)")
    customer = customer.blank? ? " " : customer
    
    logger.debug "Order Number: " + order_number
    logger.debug "Customer: " + customer
    logger.debug "Body: " + body
  end
end
