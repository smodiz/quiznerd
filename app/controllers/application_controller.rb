#:nodoc:
class ApplicationController < ActionController::Base
  add_flash_types :error, :success, :info
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception, :if => Proc.new { |c| c.request.format == 'application/html' }
end
