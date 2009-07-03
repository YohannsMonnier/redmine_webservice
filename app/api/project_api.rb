#****************************************************
#                                                   *
# Redmine Webservice - Yohann Monnier - Internethic  *
#													*
#****************************************************
 
require File.dirname(__FILE__) + '/../struct/project_dto'
require File.dirname(__FILE__) + '/../struct/boolean_dto'

class ProjectApi < ActionWebService::API::Base

  api_method :find_all,
    :returns => [[ProjectDto]]
 
   api_method :find_one_project,
    :expects => [:int],
    :returns => [ProjectDto]
      
  api_method :create_one_project,
  	:expects => [:string, :string, :string],
    :returns => [ProjectDto]

  api_method :update_one_project,
  	:expects => [:string, :string, :string],
    :returns => [ProjectDto]    

    
end
