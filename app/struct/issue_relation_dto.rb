class IssueRelationDto < ActionWebService::Struct
  member :id, :int
  member :from, :int
  member :to, :int
  member :type, :string
  member :delay, :int

  def IssueRelationDto.create relation
    IssueRelationDto.new(
      :id => relation.id,
      :from => relation.issue_from_id,
      :to => relation.issue_to_id,
      :type => relation.relation_type,
      :delay => relation.delay
    )
  end
end