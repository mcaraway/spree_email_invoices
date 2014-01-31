class Spree::Admin::EmailInvoicesController < Spree::Admin::ResourceController
  before_filter :load_email_invoice, :only => [:show, :edit, :update, :destroy, :create_order]
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
    @email_invoice = Spree::EmailInvoice.new
  end

  # GET /spree/email_invoices/1/edit
  def edit
  end

  # POST /spree/email_invoices
  def create
    @email_invoice = Spree::EmailInvoice.new(spree_email_invoice_params)

    if @email_invoice.save
      redirect_to @email_invoice, notice: 'Email invoice was successfully created.'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /spree/email_invoices/1
  def update
    if @email_invoice.update(spree_email_invoice_params)
      redirect_to @email_invoice, notice: 'Email invoice was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /spree/email_invoices/1
  def destroy
    @email_invoice.destroy
    redirect_to spree_email_invoices_url, notice: 'Email invoice was successfully destroyed.'
  end

  def create_order
    @order = Spree::Order.create
    @order.associate_user!(Spree::User.where(:email => Spree::EmailInvoices::Config[:user_email_address]).first)
    @order.line_items = @email_invoice.get_line_items(@order)
    @order.shipping_address = @email_invoice.get_shipping_address
    @order.billing_address = @email_invoice.get_shipping_address

    unless @order.next
      flash[:error] = @order.errors.full_messages.join("\n")
      render action: 'edit' and return
    end
    @order.shipping_method_id = @email_invoice.get_shipping_method.id
    @order.shipments = @email_invoice.get_shipment(@order)

    unless @order.next
      flash[:error] = @order.errors.full_messages.join("\n")
      render action: 'edit' and return
    end
    @order.update!
    @order.payments = get_payment(@order.total)

    unless @order.next
      flash[:error] = @order.errors.full_messages.join("\n")
      render action: 'edit' and return
    end
    logger.debug "************************   completing order"
    @order.update!
    unless @order.next
      flash[:error] = @order.errors.full_messages.join("\n")
      render action: 'edit' and return
    end
    @order.update!
    @order.finalize!
    logger.debug "************************   saving order"
    @order.save
    logger.debug "************************   done saving order"
    
    @email_invoice.order = @order
    
    @email_invoice.save!
    
    respond_to do |format|
      format.html { render action: 'edit' }
      format.js   { render :layout => false }
    end
  end

  def move_to_next
  end

  def get_payment(total)
    payments = Array.new

    payment = Spree::Payment.new
    payment.amount = total
    payment.order = @order
    payment.payment_method = Spree::PaymentMethod.where("name = 'Check' and environment = ?", Rails.env).first
    logger.debug "************************   saving payment total = " + total.to_s + " method : " + payment.payment_method.name
    payment.save
    logger.debug "************************   done saving payment"

    #payment.capture!

    payments << payment
  end

  # POST /spree/update_emails
  def update_emails
    Spree::EmailInvoice.get_emails
    respond_to do |format|
      format.html { redirect_to location_after_save }
      format.js   { render :layout => false }
    end
  end

  protected

  def location_after_save
    admin_email_invoices_url
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def load_email_invoice
    @email_invoice = Spree::EmailInvoice.find(params[:id])
    authorize! action, @email_invoice
  end

  # Only allow a trusted parameter "white list" through.
  def spree_email_invoice_params
    params.require(:email_invoice).permit(:subject, :date)
  end
end
