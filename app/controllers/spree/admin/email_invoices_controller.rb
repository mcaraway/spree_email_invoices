class Spree::Admin::EmailInvoicesController < Spree::Admin::ResourceController
  before_action :set_spree_email_invoice, only: [:show, :edit, :update, :destroy]
  # GET /spree/email_invoices
  def index
    params[:q] ||= {}

    # As date params are deleted if @show_only_completed, store
    # the original date so we can restore them into the params
    # after the search
    created_at_gt = params[:q][:created_at_gt]
    created_at_lt = params[:q][:created_at_lt]

    if !params[:q][:created_at_gt].blank?
      params[:q][:created_at_gt] = Time.zone.parse(params[:q][:created_at_gt]).beginning_of_day rescue ""
    end

    if !params[:q][:created_at_lt].blank?
      params[:q][:created_at_lt] = Time.zone.parse(params[:q][:created_at_lt]).end_of_day rescue ""
    end

    @search = Spree::EmailInvoice.accessible_by(current_ability, :index).ransack(params[:q])
    @email_invoices = @search.result(distinct: true).
          page(params[:page]).
          per(params[:per_page] || Spree::Config[:orders_per_page])

    @email_invoices.each do |invoice| 
      invoice.extract_invoice_info
    end
    # Restore dates
    params[:q][:created_at_gt] = created_at_gt
    params[:q][:created_at_lt] = created_at_lt
  # @spree_email_invoices = Spree::EmailInvoice.all
  end

  # GET /spree/email_invoices/1
  def show
  end

  # GET /spree/email_invoices/new
  def new
    @spree_email_invoice = Spree::EmailInvoice.new
  end

  # GET /spree/email_invoices/1/edit
  def edit
  end

  # POST /spree/email_invoices
  def create
    @spree_email_invoice = Spree::EmailInvoice.new(spree_email_invoice_params)

    if @spree_email_invoice.save
      redirect_to @spree_email_invoice, notice: 'Email invoice was successfully created.'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /spree/email_invoices/1
  def update
    if @spree_email_invoice.update(spree_email_invoice_params)
      redirect_to @spree_email_invoice, notice: 'Email invoice was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /spree/email_invoices/1
  def destroy
    @spree_email_invoice.destroy
    redirect_to spree_email_invoices_url, notice: 'Email invoice was successfully destroyed.'
  end

  # POST /spree/test_emails
  def test_emails
    logger.debug "Testing emails"

    @invoice = Spree::EmailInvoice.first
    @invoice.extract_invoice_info

    respond_to do |format|
      format.html { redirect_to location_after_save }
      format.js   { render :layout => false }
    end
  end

  def get_emails
    Mail.defaults do
      retriever_method :pop3, :address    => "pop.uniqteas.com",
                              :port       => 995,
                              :user_name  => 'orders@uniqteas.com',
                              :password   => 'B4radhur',
                              :enable_ssl => true
    end

    emails = Mail.find(:what => :last, :count => 10, :order => :asc)
    mail = emails.first
    logger.debug "Subject: " + mail.subject
    logger.debug "Body: " + mail.body.decoded
    logger.debug "Body preamble: " + mail.body.preamble
  end

  protected

  def location_after_save
    admin_email_invoices_url
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_spree_email_invoice
    @spree_email_invoice = Spree::EmailInvoice.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def spree_email_invoice_params
    params.require(:spree_email_invoice).permit(:subject, :date)
  end
end
