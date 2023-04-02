require "authenticate_user"
require 'authorize_api_request'

# app/controllers/users_controller.rb
class UsersController < ApplicationController

    def login
        auth_token = AuthenticateUser.new(login_params[:email], login_params[:password]).call
        if auth_token
            render json: { auth_token: auth_token }, status: :ok
        else
            render json: { error: 'Invalid email or password' }, status: :unauthorized
        end
    end

    def register
        @user = User.create(user_params)
        if @user.save
            response = { message: 'User created successfully'}
            render json: response, status: :created 
        else
            render json: @user.errors, status: :bad
        end 
    end

    def contact
        authorize_request = AuthorizeApiRequest.new(request.headers)
        result = authorize_request.call
        user = result[:user]

        @contact = User.where.not(email: user['email'])
        response = { data: @contact }
        render json: response, status: :ok
    end

    private

    def user_params
    params.permit(
        :name,
        :email,
        :password
    )
    end

    def login_params
        params.permit(:email, :password)
    end
end