#****************************************************
#                                                   *
# Redmine Webservice - Yohann Monnier - Internethic  *
#													*
#****************************************************

require File.dirname(__FILE__) + '/../api/deliverable_api'
require File.dirname(__FILE__) + '/../struct/deliverable_dto'


class DeliverableService < BaseService
  web_service_api DeliverableApi

  def find_project rpcname, args
   if (rpcname==:create_deliverable_for_project || rpcname==:find_deliverables_for_project)
   	 @project = Project.find_by_identifier(args[0])
   else
     @deliverable = Deliverable.find_by_id(args[0])
     @project = @deliverable.project
   end
  end

  def find_deliverable_by_id id
  	dto = DeliverableDto.create(@deliverable)

    return dto
  end

  def create_deliverable_for_project (project_identifier, deliverable_subject, deliverable_fixed_cost)

	# create the target deliverable
	deliverable = FixedDeliverable.new({:subject => deliverable_subject })
	# setting budget
	deliverable.fixed_cost = deliverable_fixed_cost
	# assigning derivable to the project
	deliverable.project = @project
	# Save the deliverable
	deliverable.save

	dto = DeliverableDto.create(deliverable)

    return dto
  end

  def update_deliverable_for_project (id_deliverable, deliverable_subject, deliverable_fixed_cost)

	# setting the subject
	@deliverable.subject = deliverable_subject
	# setting the cost
	@deliverable.fixed_cost = deliverable_fixed_cost
	# Save the deliverable
	@deliverable.save

    dto = DeliverableDto.create(@deliverable)

    return dto
  end

  def delete_deliverable_for_project id
    dto = DeliverableDto.create(@deliverable)

    return dto
  end

  def find_deliverables_for_project project_identifier
  	if @project
  		id_project = @project.id
  	else
  		id_project = 0
  	end
    deliverables = Deliverable.find(:all, :conditions => ["project_id = ? ", id_project ])
    deliverables.collect! {|x|DeliverableDto.create(x)}
    return deliverables.compact
  end

end
