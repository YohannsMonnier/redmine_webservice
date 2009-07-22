#****************************************************
#                                                   *
# Redmine Webservice - Yohann Monnier - Internethic  *
#													*
#****************************************************
 
require File.dirname(__FILE__) + '/../struct/issue_dto'
require File.dirname(__FILE__) + '/../struct/issue_status_dto'
require File.dirname(__FILE__) + '/../struct/journal_dto'
require File.dirname(__FILE__) + '/../struct/attachment_dto'
require File.dirname(__FILE__) + '/../struct/issue_relation_dto'

class IssueApi < ActionWebService::API::Base
  api_method :find_ticket_by_id,
    :expects => [:int],
    :returns => [IssueDto]
  
  api_method :find_allowed_statuses_for_issue,
    :expects => [:int],
    :returns => [[IssueStatusDto]]

  api_method :find_journals_for_issue,
    :expects => [:int],
    :returns => [[JournalDto]]

    api_method :find_attachments_for_issue,
    :expects => [:int],
    :returns => [[AttachmentDto]]

  api_method :search_tickets,
    :expects => [:string, :int, :int],
    :returns => [[IssueDto]]
  
  api_method :find_tickets_by_last_update,
    :expects => [:int, :datetime],
    :returns => [[:int]]

  api_method :find_relations_for_issue,
    :expects => [:int],
    :returns => [[IssueRelationDto]]
    
  api_method :create_issue_for_project,
    :expects => [:string,:string,:string,:string,:string,:string,:string,:string,:string,:string,:int,:string,:string],
    :returns => [IssueDto]

  api_method :update_issue_for_project,
    :expects => [:int,:string,:string,:int,:string,:string,:string,:string,:int,:int,:string,:string],
    :returns => [IssueDto]

  api_method :delete_issue_for_project,
    :expects => [:int],
    :returns => [IssueDto]
    
  api_method :find_issue_for_project,
    :expects => [:int],
    :returns => [[IssueDto]]
    
  api_method :add_time_entry_for_ticket,
    :expects => [:int, :string, :string, :string, :int],
    :returns => [IssueDto]
    
  api_method :add_comment_for_ticket,
    :expects => [:int, :string, :string],
    :returns => [IssueDto]
        
  api_method :find_issue_for_project2,
    :expects => [:string],
    :returns => [[IssueDto]]
  
  api_method :find_issue_for_user,
    :expects => [:string],
    :returns => [[IssueDto]]
     
  api_method :find_issue_for_user_by_project,
    :expects => [:string, :string],
    :returns => [[IssueDto]] 
   
  #api_method :assign_issue_to_user,
  #  :expects => [:int, :string, :string],
  #  :returns => [IssueDto]
     
   
  
end
