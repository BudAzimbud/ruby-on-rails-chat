require 'authorize_api_request'
class MessagesController < ApplicationController
    def index
        begin
            authorize_request = AuthorizeApiRequest.new(request.headers)
            result = authorize_request.call
            user = result[:user]
            @chat = Chat.where(receiver_id: user[:id]).or(Chat.where(sender_id: user[:id]))
            .select(:receiver_id, :message, :name, :email)
            .distinct(:receiver)
            .joins(:receiver)

            print @chat
            render json: { data: @chat }, status: :ok
        rescue ExceptionHandler::MissingToken, ExceptionHandler::InvalidToken, ExceptionHandler::AuthenticationError => e
            render json: { error: e.message }, status: :unauthorized
        end
    end

    def detail
        begin
            authorize_request = AuthorizeApiRequest.new(request.headers)
            result = authorize_request.call
            user = result[:user]
            @chat = Chat.where(receiver_id: params['id']).and(Chat.where(sender_id: user[:id]))
            render json: { data: @chat }, status: :ok
        rescue ExceptionHandler::MissingToken, ExceptionHandler::InvalidToken, ExceptionHandler::AuthenticationError => e
            render json: { error: e.message }, status: :unauthorized
        end
    end

    def created
        authorize_request = AuthorizeApiRequest.new(request.headers)
        result = authorize_request.call
        user = result[:user]
      
        chat = Chat.new(
          message: params_message[:message],
          receiver_id: params_message[:receiver_id],
          sender_id: user[:id]
        )
      
        if chat.save
          render json: chat, status: :created
        else
          render json: { errors: chat.errors.full_messages }, status: :unprocessable_entity
        end
    end
      
    private
    
    def params_message
        params.permit(:message, :receiver_id)
          .tap do |p|
              p[:message] = p[:message].presence
          end
    end
end
