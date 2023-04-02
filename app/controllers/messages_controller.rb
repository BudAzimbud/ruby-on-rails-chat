require 'authorize_api_request'
class MessagesController < ApplicationController
    def index
        begin
            authorize_request = AuthorizeApiRequest.new(request.headers)
            result = authorize_request.call
            user = result[:user]
            render json: { data: [] }, status: :ok
          rescue ExceptionHandler::MissingToken, ExceptionHandler::InvalidToken, ExceptionHandler::AuthenticationError => e
            render json: { error: e.message }, status: :unauthorized
          end
    end

    def created
    end
end
