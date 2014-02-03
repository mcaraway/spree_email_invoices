class Spree::EmailInvoicesJob
  include Spree::ScheduledJob
  
  run_every 4.hours
  
  def display_name
    "EmailInvoicesJob"
  end
  
  def perform
    Spree::EmailInvoice.get_emails
  end
end