#****************************************************
#                                                   *
# Redmine Webservice - Yohann Monnier - Internethic  *
#													*
#****************************************************

require File.dirname(__FILE__) + '/../struct/deliverable_dto'


class DeliverableApi < ActionWebService::API::Base

  api_method :find_deliverable_by_id,
    :expects => [:int],
    :returns => [DeliverableDto]

  api_method :create_deliverable_for_project,
    :expects => [:string,:string,:string],
    :returns => [DeliverableDto]

  api_method :update_deliverable_for_project,
    :expects => [:int,:string,:string],
    :returns => [DeliverableDto]

  api_method :delete_deliverable_for_project,
    :expects => [:int],
    :returns => [DeliverableDto]

  api_method :find_deliverables_for_project,
    :expects => [:string],
    :returns => [[DeliverableDto]]

end
