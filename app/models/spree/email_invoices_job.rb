class Spree::EmailInvoicesJob
  include Spree::ScheduledJob
  
  run_every Spree::EmailInvoices::Config[:refresh_interval].minutes
  
  def display_name
    "EmailInvoicesJob"
  end
  
  def perform
    Spree::EmailInvoice.get_emails
  end
end