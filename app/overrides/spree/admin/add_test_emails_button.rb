Deface::Override.new(:virtual_path => "spree/admin/email_invoices/index",
                     :name => "add_test_email_button",
                     :insert_bottom => "ul.actions",
                     :text => "<li id='test_email_link'><%= button_link_to Spree.t(:test_email), spree.test_email_admin_email_invoices_url, :method => :post, :icon => 'icon-refresh', :id => 'test_email_admin_email_invoices_link' %></li>",
                     :original => '3e847740dc3e7fasda1ccb56645466676j734hskk')