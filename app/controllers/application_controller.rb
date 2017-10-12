

class ApplicationController < ActionController::API
  include ExceptionHandler
  #include ResponseHelper

    before_action :authorize_request
    attr_reader :current_user

  def json_response(object, status = :ok)
    render json: object,status: status
  end
    private

     def authorize_request
       @current_user = (AuthorizeAPIRequests.new(request.headers).call)[:user]
     end

end
