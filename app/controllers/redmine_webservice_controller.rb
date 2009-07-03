#****************************************************
#                                                   *
# Redmine Webservice - Yohann Monnier - Internethic  *
#													*
#****************************************************

class RedmineWebserviceController < ActionController::Base
  before_filter :authenticate
  
  web_service_dispatching_mode :layered
  
  web_service :Project, ProjectService.new
  web_service :Ticket, IssueService.new
  web_service :Information, InformationService.new
  web_service :Deliverable, DeliverableService.new
  web_service :Priority, PriorityService.new
  web_service :ProjectBased, ProjectBasedService.new
  web_service :Status, StatusService.new
  
  def authenticate
    if params[:methodCall] && params[:methodCall][:methodName] && params[:methodCall][:methodName].include?('Information.')
      return true;
    end
    if user = authenticate_with_http_basic { |u, p| User.try_to_login(u, p) }
      User.current=(user);
      # if user is an administrator, then he can access to our webservices
      if user.admin
      	return true
      end
    end
      render :status => 401, :text => 'Access denied'
  end
end
