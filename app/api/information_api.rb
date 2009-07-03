#****************************************************
#                                                   *
# Redmine Webservice - Yohann Monnier - Internethic  *
#													*
#****************************************************

class InformationApi < ActionWebService::API::Base
  api_method :get_version,
    :returns => [[:string]]

  api_method :check_credentials,
    :expects => [:string, :string],
    :returns => [:bool]
  
end
