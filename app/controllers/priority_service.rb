#****************************************************
#                                                   *
# Redmine Webservice - Yohann Monnier - Internethic  *
#													*
#****************************************************

require File.dirname(__FILE__) + '/../api/priority_api'
require File.dirname(__FILE__) + '/../struct/priority_dto'

class PriorityService < ActionWebService::Base
  web_service_api PriorityApi
  
  def get_all
    enumerations = Enumeration::get_values('IPRI')
    prioritys = Array.new(enumerations.size)
    enumerations.each { |element| 
      prioritys.push(PriorityDto.create(element))
    }
  end
end
