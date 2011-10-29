class ProjectDto < ActionWebService::Struct

  member :id, :int
  member :identifier, :string
  member :name, :string
  member :short_description, :string
  member :issue_edit_allowed, :boolean
  member :project_saved, :boolean
  member :new_project, :boolean

  def self.create project
    ProjectDto.new(
      :id => project.id,
      :identifier => project.identifier,
      :name => project.name,
      :short_description => project.short_description,
      :issue_edit_allowed => User.current.allowed_to?(:edit_issues, project)
    )
  end

  def self.createAndReturn(project,boo_saved,boo_new)
  	return ProjectDto.new(
      :id => project.id,
      :identifier => project.identifier,
      :name => project.name,
      :short_description => project.short_description,
      :issue_edit_allowed => User.current.allowed_to?(:edit_issues, project),
      :project_saved => boo_saved,
      :new_project => boo_new
      )
  end
end
