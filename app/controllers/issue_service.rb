#****************************************************
#                                                   *
# Redmine Webservice - Yohann Monnier - Internethic  *
#													*
#****************************************************

require File.dirname(__FILE__) + '/../api/issue_api'
require File.dirname(__FILE__) + '/../struct/issue_dto'
require File.dirname(__FILE__) + '/../struct/issue_status_dto'
require File.dirname(__FILE__) + '/../struct/journal_dto'
require File.dirname(__FILE__) + '/../struct/attachment_dto'
require 'enumerator'

class IssueService < BaseService
  web_service_api IssueApi

  def find_project rpcname, args
   if rpcname==:search_tickets
     @query = retrieve_query(args[0], args[1], args[2])
     @project = @query.project
   elsif ( rpcname==:find_tickets_by_last_update || rpcname==:find_issue_for_project )
     @project = Project.find(args[0])
   elsif ( rpcname==:create_issue_for_project || rpcname==:find_issue_for_project2 )
     @project = Project.find_by_identifier(args[0])
   elsif ( rpcname==:find_issue_for_user )
   	 @user = User.find_by_login(args[0])
   elsif  ( rpcname==:find_issue_for_user_by_project )
   	 @project = Project.find_by_identifier(args[0])
   	 @user = User.find_by_login(args[1])
   else
     @issue = Issue.find(args[0])
     @project = @issue.project
   end
#rescue
#      false
  end

  def create_issue_for_project (project_identifier, task_subject, task_description,task_tracker,task_priority, task_created_on, task_updated_on, task_start_date, task_due_date, task_estimated_hours, deliverable_identifier, user_identifier, user_role)
		
		# number of estimated hours
		str_estimated_hours = task_estimated_hours
		# Priority of the task
		priorities = Enumeration.get_values('IPRI')
		default_priority = priorities[0]
		task_priority = default_priority unless task_priority = priorities[task_priority.to_i()]
		
		# finding tracker attribute
		#tracker_to_be_assign = nil		
		tracker_to_be_assign =  @project.trackers.find(:first);			
		all_project_tracker = @project.trackers.find(:all);	
		all_project_tracker.each do |tracker|
			if task_tracker == tracker.name
				tracker_to_be_assign = tracker
			end
		end


		i = Issue.new 	:project => @project,
						:subject => task_subject[0, limit_for(Issue, 'subject')],
						:description => task_description[0, limit_for(Issue, 'subject')], 
						:priority => task_priority,
						:created_on => Time.parse(task_start_date),
						:updated_on => Time.parse(task_start_date),
						:start_date => Time.parse(task_start_date),
						:estimated_hours => str_estimated_hours,
						:due_date => Time.parse(task_due_date)

				# assigning default status and tracker type
				i.status = IssueStatus.default
				i.tracker = tracker_to_be_assign
				# for this version the author of the task is always the webservice user
				#####i.author = find_or_create_user @@projectManager, @project, @@price_per_hour_of_projectManager , @@role_of_projectManager 
				i.author = User.current
				## Recording the issue
				##--------------------
				i.save

				# Manage Deliverable relation
				if deliverable_identifier != 0
					deliverable = Deliverable.find_by_id(deliverable_identifier)
					if deliverable
						if deliverable.project == i.project
							deliverable.issues << i
							deliverable.save
						end
					end
				end

				# Manage issue assignation 
				if user_identifier
					assign_issue_to_user(i, user_identifier,user_role)
				end
		
	dto = IssueDto.create(i)
    complete_dto(i, dto)
    return dto

  end
  
  def update_issue_for_project (id_issue, task_name, task_description,task_priority, task_start_date, task_due_date, task_estimated_hours, update_note, done_ratio, deliverable_identifier, user_identifier, user_role) 

	notes = update_note
	journal = @issue.init_journal(User.current, notes)
	# updating data of the issue
	if (@issue.subject != task_name[0, limit_for(Issue, 'subject')] )
		@issue.subject = task_name[0, limit_for(Issue, 'subject')]
	end
	if (@issue.description != task_description[0, limit_for(Issue, 'subject')] )
		@issue.description = task_description[0, limit_for(Issue, 'subject')]
	end
	# Priority of the task
		priorities = Enumeration.get_values('IPRI')
		task_priority = @issue.priority unless task_priority = priorities[task_priority.to_i()]
	
	if ( @issue.priority != task_priority )
		@issue.priority = task_priority
	end
	if (((@issue.start_date.yday) != Time.parse(task_start_date).yday) or ((@issue.start_date.year) != Time.parse(task_start_date).year))
		@issue.start_date = Date.parse(task_start_date)
	end
	if (@issue.estimated_hours != task_estimated_hours)
		@issue.estimated_hours = task_estimated_hours
	end
	if (((@issue.due_date.yday) != Time.parse(task_due_date).yday) or ((@issue.due_date.year) != Time.parse(task_due_date).year))
		@issue.due_date = Date.parse(task_due_date)
	end
	
	# Manage issue assignation 
	if user_identifier
		assign_issue_to_user(@issue, user_identifier,user_role)
	end
	
	# Manage done ratio
	if done_ratio != @issue.done_ratio		
		@issue.done_ratio = done_ratio
	end 
	
	# Manage Deliverable relation
	if deliverable_identifier != 0
		deliverable = Deliverable.find_by_id(deliverable_identifier)
		if deliverable
			if deliverable.id != @issue.deliverable_id
				if deliverable.project == @issue.project
					deliverable.issues << @issue
					deliverable.save
				end
			end
		end
	end
	
	## Recording the issue
	@issue.save

    dto = IssueDto.create(@issue)
    complete_dto(@issue, dto)
    return dto
  end
  
  def delete_issue_for_project id
    dto = IssueDto.create(@issue)
    complete_dto(@issue, dto)
    return dto
  end
  
  def find_issue_for_project projectid
    issues = Issue.find(:all, :conditions => ["project_id = ? ", @project.id])
    issues.collect! {|x|complete_dto(x, IssueDto.create(x))}
    return issues
  end

  def find_issue_for_project2 projectidentifier
    issues = Issue.find(:all, :conditions => ["project_id = ? ", @project.id])
    issues.collect! {|x|complete_dto(x, IssueDto.create(x))}
    return issues
  end
  
  def find_issue_for_user userlogin
    issues = Issue.find(:all, :include => [:project, :status,], :conditions => ["assigned_to_id = ? AND #{IssueStatus.table_name}.is_closed=?", @user.id, false])
    issues.collect! {|x|complete_dto(x, IssueDto.create(x))}
    return issues
  end
  
  def find_issue_for_user_by_project project_id, userlogin 
    issues = Issue.find(:all, :include => [:project, :status,], :conditions => ["assigned_to_id = ? AND #{IssueStatus.table_name}.is_closed=? AND project_id = ? ", @user.id, false, @project.id])
    issues.collect! {|x|complete_dto(x, IssueDto.create(x))}
    return issues
  end
  
  
  def find_ticket_by_id(id)
    dto = IssueDto.create(@issue)
    complete_dto(@issue, dto)
    return dto
  end
  
  def add_time_entry_for_ticket(task_id, user_identifier, spent_time, comments)
  	# retrieve user
  	worker_user = User.find_by_login(user_identifier)
  	# retrieve the default activity
  	act_enumerations = Enumeration::get_values('ACTI')
  	activity_to_assign = act_enumerations.first
	act_enumerations.each do |activity|
		if activity.is_default == true
			# la méthode tostring de l'objet enumération retourne le nom de l'objet
			activity_to_assign = activity
		end
	end

  	# add a	Time Entry for this issue
  	time_entry = TimeEntry.new(:project => @project, :issue => @issue, :user => worker_user, :spent_on => Date.today)
  	time_entry.attributes = {:hours => spent_time, :comments => comments, :activity_id => activity_to_assign.id }
  	# save the time entry
  	if time_entry.valid?
  		time_entry.save
  	end
  	
  	# prepare comment
	notes = comments
	journal = @issue.init_journal(worker_user, comments)
	## Recording the issue
	@issue.save
	
    dto = IssueDto.create(@issue)
    complete_dto(@issue, dto)
    return dto
  end
  
  def add_comment_for_ticket(task_id, user_identifier, comments)
  	# retrieve user
  	worker_user = User.find_by_login(user_identifier)
	# prepare comment
	notes = comments
	journal = @issue.init_journal(worker_user, comments)
	## Recording the issue
	@issue.save
	
    dto = IssueDto.create(@issue)
    complete_dto(@issue, dto)
    return dto
  end
  
  def find_allowed_statuses_for_issue(id)
    statuses = @issue.new_statuses_allowed_to(User.current)
    
    if !statuses.include?(@issue.status) 
      statuses.unshift(@issue.status);
    end
    
    statuses.collect! {|x|IssueStatusDto.create(x)}
    return statuses.compact
  end
  
  def find_journals_for_issue(id)
    journals = @issue.journals.find(:all, :conditions => ["notes IS NOT NULL"])
    journals.collect! {|x|JournalDto.create(x)}
    return journals.compact
  end
  
  def find_attachments_for_issue(id)
    attachments = @issue.attachments
    attachments.collect! {|x|AttachmentDto.create(x)}
    return attachments
  end
  
  
  def assign_issue_to_user (issue, user_identifier, user_role)
  	#def assign_issue_to_user (issue_id, user_identifier, user_role)
  	if issue
  		project = issue.project
  	#if @project and @issue
  		# Finding the user by identifier
  		user_to_be_assigned = User.find_by_login(user_identifier)
  		# if the user has been found
  		if user_to_be_assigned
  			# if the user is not member of the project, we add him
			if !user_to_be_assigned.member_of?(project)
			
  					# searching the role given by the webservice User
					role_in_project = Role.find(:first, :conditions => ["name = ?", user_role])
					# if no role is found we will give him this role
					if !role_in_project
						role_in_project =  Role.find_by_id(5)
					end

				Member.create(:user => user_to_be_assigned, :project => project, :role => role_in_project)
				# TODO : #
				#, :rate => price_per_hour)
				
				# we reload user right 
				user_to_be_assigned.reload
			end
			
  			issue.assigned_to = user_to_be_assigned
  			#issue.save
  		end
  	end
    #dto = IssueDto.create(@issue)
    #complete_dto(@issue, dto)
    #return dto
  end
  

  def search_tickets(query_string, project_id, query_id)
    if @query.valid?
      issues = Issue.find :all,
                         :include => [ :assigned_to, :status, :tracker, :project, :priority, :category, :fixed_version ],
                         :conditions => @query.statement
      issues.collect! {|x|complete_dto(x, IssueDto.create(x))}
      return issues.compact
    else
      nil
    end
  end
  
  def find_tickets_by_last_update(projectid, timestamp)
    issues = Issue.find(:all, :conditions => ["project_id = ? AND updated_on >= ?", projectid, timestamp])
    issues.collect! {|x|x.id}
    return issues.compact
  end

  def find_relations_for_issue id
    relations = @issue.relations
    relations.collect! {|x|IssueRelationDto.create(x)}
    return relations.compact
  end
  
  private
  def retrieve_query query_string, project_id, query_id
    query = nil
    if query_id!=nil && project_id!=nil && project_id>0 && query_id>0 then
      project = Project.find(project_id)
      begin
        # Code form Issue_helper
        visible = ARCondition.new(["is_public = ? OR user_id = ?", true, User.current.id])
        visible << (["project_id IS NULL OR project_id = ?", project.id])

        query = Query.find(query_id, :conditions => visible.conditions)
      rescue
        query = Query.new
      end
      query.project = project
   else
      querydecoder = QueryStringDecoder.new(query_string)
      @project = querydecoder.project
      query = querydecoder.query
    end
    return query
  end

  def complete_dto issue, dto
    statuses = issue.new_statuses_allowed_to(User.current)
    if !statuses.include?(issue.status)
      statuses.unshift(issue.status);
    end
    statuses.collect! {|x|IssueStatusDto.create(x)}
    dto.all_status = statuses.compact

	
    #journals = issue.journals.find(:all, :conditions => ["notes IS NOT NULL"])
    #journals.collect! {|x|JournalDto.create(x)}
    #dto.all_journals = journals.compact

    #attachments = issue.attachments
    #attachments.collect! {|x|AttachmentDto.create(x)}
    #dto.all_attachments = attachments.compact
    
   project = issue.project
   if project
    	dto.project_name = project.name
    end

    enumerations = Enumeration::get_values('IPRI')
	# on retrouve la bonne priorité et on l'enregistre
	dto.priority = ""
	enumerations.each do |priorite|
		if priorite.id == issue.priority_id
			# la méthode tostring de l'objet enumération retourne le nom de l'objet
			dto.priority = priorite.to_s()
		end
	end
	
    relations = issue.relations
    relations.collect! {|x|IssueRelationDto.create(x)}
    dto.all_relations = relations.compact

    return dto
  end
  
  def limit_for(klass, attribute)
	  klass.columns_hash[attribute.to_s].limit
  end 
  
end
