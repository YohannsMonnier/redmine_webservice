#****************************************************
#                                                   *
# Redmine Webservice - Yohann Monnier - Internethic  *
#													*
#****************************************************

require File.dirname(__FILE__) + '/../api/project_api'
require File.dirname(__FILE__) + '/../struct/project_dto'
require File.dirname(__FILE__) + '/../struct/boolean_dto'

class ProjectService < ActionWebService::Base

  web_service_api ProjectApi
  
  def find_all 
    projects = Project.find(:all, :joins => :enabled_modules,
                  				  :conditions => [ "enabled_modules.name = 'issue_tracking' AND #{Project.visible_by}"])
    projects.collect! {|x|ProjectDto.create(x)}

    return projects
  end
  
  def find_one_project(projectIdentifier)
  	# retrieving project
  	project = Project.find_by_identifier(projectIdentifier, :conditions => [ "#{Project.visible_by}"])
   	boo_NewProject = false
	boo_SavedProject = false
	# return project if found
	if project
		dto_Project = ProjectDto.createAndReturn(project, boo_SavedProject, boo_NewProject)
  	else
  		dto_Project = nil
  	end
  end
  
  def create_one_project(projectIdentifier, projectName, projectDescription)
  	# check user right
  	if User.current.admin?
    	# I look for a project with this identifier
    	project = Project.find_by_identifier(projectIdentifier)
    
    	boo_NewProject = false
    	boo_SavedProject = false
    
    	if !project
		
			# Create the new project
			project = Project.new 	:name => projectName,
									:description => projectDescription,
									:is_public => 0
			# Giving it the identifier
			project.identifier = projectIdentifier
			# Enable modules for the created project
			project.enabled_module_names = ['issue_tracking','time_tracking','wiki','repository','budget_module']
			# Enable all the trackers to the project
			allTrackersCollection =  Tracker.find(:all)
			allTrackersCollection.each do |tracker|
				project.trackers << tracker
			end 
			# Save the new project
			if (project.save)
				boo_SavedProject = true
			else
				boo_SavedProject = false
			end
			# It is a new project
			boo_NewProject = true
		else
			boo_SavedProject = false
			boo_NewProject = false
		end 
	
		dto_Project = ProjectDto.createAndReturn(project,boo_SavedProject,boo_NewProject)
		return dto_Project	
	else
      	return nil
	end
  end
  
  def update_one_project(projectIdentifier, projectName, projectDescription)
    project = Project.find_by_identifier(projectIdentifier, :conditions => [ "#{Project.visible_by}"])
    
    boo_NewProject = false
    
    if !project
		return nil
	elsif !User.current.allowed_to?({:controller => "projects", :action => "edit"} , project)
		return nil
	else
		# Update the existing project
		project.name = projectName
		project.description = projectDescription
		project.is_public = 0
		
		# Update this project
		if (project.save)
			boo_SavedProject = true
		else
			boo_SavedProject = false
		end
	end 
	
	dto_Project = ProjectDto.createAndReturn(project,boo_SavedProject,boo_NewProject)
		
	return dto_Project	
end


  
end
