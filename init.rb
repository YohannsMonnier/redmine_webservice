require 'redmine'

RAILS_DEFAULT_LOGGER.info 'Starting Redmine Webservice plugin'


Redmine::Plugin.register :redmine_webservice do
  name 'Redmine Webservice Plugin'
  author 'Yohann Monnier - Internethic'
  description 'This plugin implements a webservice API in Redmine'
  url 'http://github.com/YohannsMonnier/redmine_webservice/'
  version '0.0.3'
end
