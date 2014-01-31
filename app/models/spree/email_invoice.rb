module Spree
  class EmailInvoice < ActiveRecord::Base
    has_many :email_invoice_items
    belongs_to :order
    belongs_to :user
    #attr_accessible :email_invoice_items, :address, :body, :city, :customer, :email, :from_address, :message_date, :order_number, :phone, :shipping_method, :state, :subject, :zip
    def self.is_invoice(mail)
      correct_email = mail.from[0] == Spree::EmailInvoices::Config[:from_email_address]
      correct_subject = mail.subject.start_with? "CoffeeForLess Pick Slip for Order #"

      correct_email && correct_subject
    end

    def self.get_emails
      Mail.defaults do
        retriever_method :pop3, :address    => Spree::EmailInvoices::Config[:pop_server],
                              :port       => Spree::EmailInvoices::Config[:pop_port],
                              :user_name  => Spree::EmailInvoices::Config[:pop_user_email_address],
                              :password   => Spree::EmailInvoices::Config[:pop_user_password],
                              :enable_ssl => Spree::EmailInvoices::Config[:pop_enable_ssl]
      end

      emails = Mail.find(:what => :last, :count => Spree::EmailInvoices::Config[:pop_retrieve_email_count], :order => :asc)
      emails.each do |mail|
        next unless Spree::EmailInvoice.is_invoice(mail)
        email_invoice = Spree::EmailInvoice.new(
        :subject => mail.subject,
        :message_date => mail.date,
        :body => mail.body.decoded,
        :email => Spree::EmailInvoices::Config[:user_email_address],
        :shipping_state => 'ready' )
        email_invoice.extract_invoice_info

        next unless Spree::EmailInvoice.find_by_order_number(email_invoice.order_number) == nil
        email_invoice.save!
      end
    end

    def line_items
      line_items = Array.new
      email_invoice_items.each do |item|

        line_item = Spree::LineItem.new
        line_item.variant = variant
        line_item.tax_category = variant.product.tax_category
        line_item.quantity = item.count
        line_item.price = 0.0

        line_items << line_item
      end
      line_items
    end

    def get_line_items(order)
      line_items = Array.new
      email_invoice_items.each do |item|
        variant = Spree::Variant.where("sku = ?", item.extract_sku).first
        logger.debug "************************   variant = " + variant.sku
        logger.debug "************************   product = " + variant.product.name

        line_item = Spree::LineItem.new
        line_item.variant = variant
        line_item.order = order
        line_item.tax_category = variant.product.tax_category
        line_item.quantity = item.count
        line_item.price = 0.0
        logger.debug "************************   saving line_item"
        line_item.save
        logger.debug "************************   done saving line_item"

        line_items << line_item
      end
      line_items
    end

    def get_shipping_address
      ship_address = Spree::Address.where("firstname =? and lastname = ?", first_name, last_name ).first

      if ship_address.nil?
        ship_address = Spree::Address.create
        ship_address.firstname = first_name
        ship_address.lastname = last_name
        ship_address.address1 = address
        ship_address.city = city
        ship_address.state = Spree::State.where("name = ?",state).first
        ship_address.zipcode = zip
        ship_address.country = Spree::Country.where("iso = ?", "US").first
        ship_address.phone = phone
      end

      ship_address
    end

    def country
      Spree::Country.where("iso = ?", "US").first
    end

    def full_name
      first_name + " " + last_name
    end

    def get_shipment(order)
      shipments = Array.new
      shipping_methods = Array.new

      shipping_methods << get_shipping_method
      shipment = Spree::Shipment.new
      shipment.order = order
      shipment.shipping_methods = shipping_methods
      shipment.address = get_shipping_address

      shipment.save
      shipments << shipment

      shipments
    end

    def get_shipping_method
      Spree::ShippingMethod.find_by_name("Flat Rate")
    end

    def has_order?
      return !order.nil?
    end

    def first_name
      customer.blank? ? "" : customer.split.first
    end

    def last_name
      customer.blank? ? "" : customer.split.last
    end

    def extract_invoice_info
      self.order_number = subject.split("#")[1].strip
      m1 = /(?<=Name:)(.*?)(?=<br>)/m.match(body)
      self.customer = m1.nil? ? "" : m1[0].strip

      m1 = /(?<=Phone number:)(.*?)(?=<br>)/m.match(body)
      self.phone = m1.nil? ? "" : m1[0].strip

      extract_address( /(?<=Address:)(.*?)(?=<\/td>)/m.match(body))
      extract_shipping_method( /(?<=Shipping Method:)(.*?)(?=<\/td>)/m.match(body))
      extract_order_items( /(?<=Ordered)(.*?)(?=<\/tbody>)/m.match(body))
    end

    def extract_shipping_method(shipping_block)
      return unless !shipping_block.nil?
      #puts "evaluating >>>>" + shipping_block[0] + "<<<<"
      self.shipping_method = shipping_block[0][shipping_block[0].rindex(">")+2,shipping_block[0].length-4].strip
    end

    def extract_order_items(item_block)
      return unless !item_block.nil?

      stripped = item_block[0][item_block[0].rindex("<tbody>")+7,item_block[0].length-1]

      stripped = stripped.gsub("<tr>","")
      stripped = stripped[0,stripped.length-5].split("</tr>")

      stripped.each do |entry|
        entry = entry.gsub( /(<td.*?>)/, '')

        item_list = entry.split("</td>")

        self.email_invoice_items.build(
        :sku => item_list[0].blank? ? "" : item_list[0].strip,
        :name => item_list[1].blank? ? "" : item_list[1].strip,
        :count => item_list[2].blank? ? "" : item_list[2].strip
        )
      end
    end

    def extract_address(address_block)
      return unless !address_block.nil?
      address_normal = address_block[0].sub("<br>",",").split(",")

      self.address = address_normal.first.strip
      self.city = address_normal[1].strip
      self.state = address_normal[2].strip
      self.zip = address_normal.last.strip
    end

    def to_s
      string = "id: " + id.to_s + "\n";
      string += "order_number: " + order_number + "\n";
      string += "subject: " + subject + "\n";
      string += "customer: " + customer + "\n";
      string += "shipping_method: " + shipping_method + "\n";
      string += "company: " + (company.nil? ? "" : company) + "\n";
      string += "address: " + address + "\n";
      string += "city: " + city + "\n";
      string += "state: " + state + "\n";
      string += "zip: " + zip + "\n";
      string += "phone: " + phone + "\n";
      string += "email: " + email + "\n";
      string += "shipping_state " + shipping_state + "\n";

      string
    end
  end
end


require_dependency 'spree/email_invoice/scopes'