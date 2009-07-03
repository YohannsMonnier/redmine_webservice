#****************************************************
#                                                   *
# Redmine Webservice - Yohann Monnier - Internethic  *
#													*
#****************************************************

require File.dirname(__FILE__) + '/../api/status_api'
require File.dirname(__FILE__) + '/../struct/issue_status_dto'

class StatusService < ActionWebService::Base
  web_service_api StatusApi
  
  def get_all
    statuses = IssueStatus.find(:all)
    statuses.collect!{|x|IssueStatusDto.create(x)}
    return statuses
  end
end
