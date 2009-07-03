class IssueStatusDto < ActionWebService::Struct
#          <id xsi:type="xsd:int">2</id>
#          <name xsi:type="xsd:string">Assigned</name>
#          <is_closed xsi:type="xsd:boolean">false</is_closed>
#          <is_default xsi:type="xsd:boolean">false</is_default>
#          <position xsi:type="xsd:int">2</position>
  member :id, :int
  member :name, :string
  member :is_closed, :bool
  member :is_default, :bool
  
  def IssueStatusDto.create status
    IssueStatusDto.new(
      :id => status.id,
      :name => status.name,
      :is_closed => status.is_closed,
      :is_default => status.is_default
    )
  end
end