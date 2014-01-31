Deface::Override.new(:virtual_path => "spree/admin/email_invoices/index",
                     :name => "add_update_email_button",
                     :insert_bottom => "ul.actions",
                     :text => "<li id='update_email_link'><%= button_link_to Spree.t(:test_email), spree.update_emails_admin_email_invoices_url, :icon => 'icon-plus', :id => 'upate_emails_admin_email_invoices_link', :method => :post %></li>",
                     :original => '3e847740dc3e7fasda1ccb56645466676j734hskk')