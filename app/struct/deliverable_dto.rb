
class DeliverableDto < ActionWebService::Struct
  member :id, :int
  member :project_id, :int
  member :subject, :string
  member :fixed_cost, :string


  def self.create deliverable

    return DeliverableDto.new(
      :id => deliverable.id,
      :project_id => deliverable.project_id,
      :subject => deliverable.subject,
      :fixed_cost => deliverable.fixed_cost
    )

  end
end
