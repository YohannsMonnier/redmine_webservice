#****************************************************
#                                                   *
# Redmine Webservice - Yohann Monnier - Internethic  *
#													*
#****************************************************

class BaseService < ActionWebService::Base
  before_invocation :find_project
  before_invocation :authorize

  attr_accessor(:project)

  def initialize
    super
    @@authorizemap = Hash.new(nil)
    
    @@authorizemap[IssueService] = Hash.new(nil)
    @@authorizemap[IssueService][:find_ticket_by_id] = {:ctrl => :issues, :action => :show}
    @@authorizemap[IssueService][:find_allowed_statuses_for_issue] = {:ctrl => :issues, :action => :show}
    @@authorizemap[IssueService][:find_journals_for_issue] = {:ctrl => :issues, :action => :show}
    @@authorizemap[IssueService][:find_attachments_for_issue] = {:ctrl => :issues, :action => :show}
    @@authorizemap[IssueService][:search_tickets] = {:ctrl => :issues, :action => :index}
    @@authorizemap[IssueService][:find_tickets_by_last_update] = {:ctrl => :issues, :action => :show}
    @@authorizemap[IssueService][:find_relations_for_issue] = {:ctrl => :issues, :action => :show}
    @@authorizemap[IssueService][:delete_ticket_for_project] = {:ctrl => :issues, :action => :show}
    
    @@authorizemap[ProjectBasedService] = Hash.new(nil)
    @@authorizemap[ProjectBasedService][:get_trackers_for_project] = {:ctrl => :issues, :action => :index}
    @@authorizemap[ProjectBasedService][:get_issue_categorys_for_project] = {:ctrl => :issues, :action => :index}
    @@authorizemap[ProjectBasedService][:get_members_for_project] = {:ctrl => :issues, :action => :index}
    @@authorizemap[ProjectBasedService][:get_versions_for_project] = {:ctrl => :issues, :action => :index}
    @@authorizemap[ProjectBasedService][:get_statuses_for_project] = {:ctrl => :issues, :action => :index}
    @@authorizemap[ProjectBasedService][:get_issue_custom_fields_for_project] = {:ctrl => :issues, :action => :index}
    @@authorizemap[ProjectBasedService][:get_queries_for_project] = {:ctrl => :issues, :action => :index}    
  end

  def find_project rpcname, args
    return false
  end

  def authorize rpcname, args
		#	if @@authorizemap[self.class][rpcname][:ctrl] && @@authorizemap[self.class][rpcname][:action]
		#    	 ctrl = @@authorizemap[self.class][rpcname][:ctrl]
		#        action = @@authorizemap[self.class][rpcname][:action]
		#        User.current.allowed_to?({:controller => ctrl, :action => action}, @project)
		#    else
		#      return false
		#    end
		#    rescue false
	return true
  end
  
end
