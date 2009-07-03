class IssueCategoryDto < ActionWebService::Struct
#          <id xsi:type="xsd:int">2</id>
#          <project_id xsi:type="xsd:int">3</project_id>
#          <name xsi:type="xsd:string">cat2_1</name>
#          <assigned_to_id xsi:nil="true"></assigned_to_id>
  member :id, :int
  member :name, :string
  
  def IssueCategoryDto.create category
    IssueCategoryDto.new(
      :id => category.id,
      :name => category.name
    )
  end
end