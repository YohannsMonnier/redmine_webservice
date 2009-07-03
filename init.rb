require 'redmine'

RAILS_DEFAULT_LOGGER.info 'Starting Redmine Webservice plugin'


Redmine::Plugin.register :redmine_webservice do
  name 'Redmine Webservice Plugin'
  author 'Yohann Monnier Thanks to Sven Krzyzak'
  description 'This plugin implements a webservice API in Redmine'
  version '0.0.2'
end
