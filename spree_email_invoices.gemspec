# encoding: UTF-8
Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_email_invoices'
  s.version     = '0.0.1'
  s.summary     = 'Adds the ability to create invoices from emails'
  s.description = 'Adds the ability to create invoices from emails'
  s.required_ruby_version = '>= 1.8.7'

  s.author    = 'Michael Caraway'
  # s.email     = 'you@example.com'
  # s.homepage  = 'http://www.spreecommerce.com'

  s.files       = `git ls-files`.split("\n")
  s.test_files  = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_path = 'lib'
  s.requirements << 'none'

  s.add_dependency 'spree_core', '~> 2.1.0'
  s.add_dependency 'mail'
  
  s.add_development_dependency 'pry'
  s.add_development_dependency 'webmock'
  s.add_development_dependency 'simplecov'  
end
