Deface::Override.new(:virtual_path => "spree/admin/shared/_configuration_menu",
                     :name => "add_email_invoices_settings_tab",
                     :insert_bottom => "[data-hook='admin_configurations_sidebar_menu'], #admin_configurations_sidebar_menu[data-hook]",
                     :text => "<li<%== ' class=\"active\"' if controller.controller_name == 'theme_settings' %>><%= link_to \"Email Invoices\", edit_admin_email_invoices_settings_path %></li>",
                     :original => '3e847740dc3e7f924aba1ccb56645466676j734hskk')