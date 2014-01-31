module Spree
  class EmailInvoice < ActiveRecord::Base
    cattr_accessor :search_scopes do
      []
    end

    def self.add_search_scope(name, &block)
      self.singleton_class.send(:define_method, name.to_sym, &block)
      search_scopes << name.to_sym
    end

    def self.simple_scopes
      [
        :ascend_by_message_date,
        :descend_by_message_date,
        :ascend_by_subject,
        :descend_by_subject
      ]
    end

    def self.add_simple_scopes(scopes)
      logger.debug "************************************* adding scopes"
      scopes.each do |name|
        parts = name.to_s.match(/(.*)_by_(.*)/)
        self.scope(name.to_s, -> { order("#{EmailInvoice.quoted_table_name}.#{parts[2]} #{parts[1] == 'ascend' ?  "ASC" : "DESC"}") })
      end
    end

    add_simple_scopes simple_scopes
  end
end