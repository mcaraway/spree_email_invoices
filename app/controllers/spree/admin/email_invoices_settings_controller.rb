class Spree::Admin::EmailInvoicesSettingsController < Spree::Admin::BaseController

  def edit
    @config = Spree::EmailInvoicesConfiguration.new
    @pop_config = [:pop_server, :pop_port, :pop_enable_ssl, :pop_user_email_address, :pop_user_password, :refresh_interval]
    @user_config = [:user_email_address, :from_email_address]
  end

  def update
    config = Spree::EmailInvoicesConfiguration.new

    params.each do |name, value|
      next unless config.has_preference? name
      config[name] = value
    end

    redirect_to edit_admin_email_invoices_settings_path
  end

end


