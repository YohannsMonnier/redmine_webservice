class PriorityDto < ActionWebService::Struct
  member :id, :int
  member :name, :string
  member :is_default, :bool
  member :position, :int

  def self.create enum
    PriorityDto.new(
      :id => enum.id,
      :name => enum.name,
      :is_default => enum.is_default,
      :position => enum.position
    )
    rescue
      nil
  end
end