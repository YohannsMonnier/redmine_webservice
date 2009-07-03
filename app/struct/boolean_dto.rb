class BooleanDto < ActionWebService::Struct


  member :validate, :string
  
  def self.create booleanAnswer
    return BooleanDto.new(:validate => booleanAnswer)
  end
 
end
