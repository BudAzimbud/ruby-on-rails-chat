require "#{Rails.root}/app/auth/authenticate_user"
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