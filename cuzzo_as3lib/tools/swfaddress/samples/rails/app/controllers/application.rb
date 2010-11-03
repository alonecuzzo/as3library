# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base

  helper :all # include all helpers, all the time
  protect_from_forgery # :secret => '05f55579b17afdf0d414290962551fd6'

  layout 'front'
  
end
