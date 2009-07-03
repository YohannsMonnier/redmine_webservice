#****************************************************
#                                                   *
# Redmine Webservice - Yohann Monnier - Internethic  *
#													*
#****************************************************

require File.dirname(__FILE__) + '/../struct/priority_dto'

class PriorityApi < ActionWebService::API::Base
  api_method :get_all,
    :returns => [[PriorityDto]]
end
