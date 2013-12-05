Deface::Override.new(:virtual_path => "spree/admin/shared/_menu",
                     :name => "add_email_invoices_settings_link",
                     :insert_bottom => "[data-hook='admin_tabs'], #admin_tabs[data-hook]",
                     :partial => "spree/admin/shared/email_invoices_tab",
                     :original => '334898j740dc3e7f924aba1ccb566e9898f73734hskk')