#****************************************************
#                                                   *
# Redmine Webservice - Yohann Monnier - Internethic  *
#													*
#****************************************************

require File.dirname(__FILE__) + '/../struct/issue_status_dto'

class StatusApi < ActionWebService::API::Base
  api_method :get_all,
    :returns => [[IssueStatusDto]]
end
