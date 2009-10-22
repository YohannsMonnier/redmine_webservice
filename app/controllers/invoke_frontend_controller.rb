#****************************************************
#                                                   *
# Redmine Webservice - Yohann Monnier - Internethic  *
#													*
#****************************************************

class InvokeFrontendController < RedmineWebserviceController
  web_service_scaffold :invoke

  def authenticate
	    if user = User.try_to_login('devel', 'devel')
	      User.current=(user);
	      return true
	    end
    render :status => 401, :text => 'Access denied'
  end
end
