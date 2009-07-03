class CustomValueDto < ActionWebService::Struct

  member :custom_field_id, :int
  member :value, :string
  
  def self.create value
    CustomValueDto.new(
      :custom_field_id => value.custom_field_id,
      :value => value.value
    )
  end
end