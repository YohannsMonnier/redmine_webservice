class IssueCustomFieldDto < ActionWebService::Struct

  member :id, :int
  member :name, :string
  member :type, :string
  member :min, :int
  member :max, :int
  member :default_value, :string
  member :regex, :string
  member :is_required, :boolean
  member :is_filter, :boolean
  member :possible_values, [:string]
  member :trackers, [:int]

  def self.create field
    IssueCustomFieldDto.new(
      :id => field.id,
      :name => field.name,
      :type => field.field_format,
      :min => field.min_length,
      :max => field.max_length,
      :default_value => field.default_value,
      :regex => field.regexp,
      :is_required => field.is_required,
      :is_filter => field.is_filter,
      :possible_values => field.field_format=="list" ? field.possible_values : nil,
      :trackers => field.trackers.collect { |e| e.id }
    )
  end
end