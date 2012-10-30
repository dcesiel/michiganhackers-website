require "pp"
class ApplicationController < ActionController::Base
  include SessionHelper
  
  protect_from_forgery

  around_filter :request_exception_wrapper
  rescue_from AbstractController::ActionNotFound, with: :render_404
  rescue_from ActionController::RoutingError, with: :render_404
  
  protected
  
    # Handler for redirecting to the 404 page
    def render_404(error)
      @error_message = error
      logger.error error.backtrace if Rails.env.development?
      render template: "static_pages/error", status: 404
    end

  private
  
    def request_exception_wrapper
      begin
          yield
      rescue Exception => e
        render_404(e)
      end
    end
  
end
