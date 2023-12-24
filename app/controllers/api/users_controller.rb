module Api
  class UsersController < ApplicationController
    before_action :get_user, only: [:show, :destroy]

    def index
      @users = User.all

      respond_to :json
    end

    def create
      @user = User.new(user_params)

      begin
        @user.save!

        render :show
      rescue => error
        render_error(error.message)
      end
    end

    def show
      respond_to :json
    end

    def destroy
      begin
        @user.destroy!
        render_success('Eliminación exitosa')
      rescue => error
        render_error(error.message)
      end
    end

    def login
      user = User.find_by(email: params[:email])

      if user && user.authenticate(params[:password])
        session[:user_id] = user.id

        render_success('Inicio de sesión exitoso')
      else
        render_error('Credenciales inválidas')
      end
    end

    def logout
      session[:user_id] = nil
      render_success('Logout')
    end

    private

    def user_params
      params.require(:user).permit(:name, :email, :password)
    end

    def get_user
      begin
        @user = User.find(params[:id])
      rescue => error
        render_error(error.message)
      end
    end
  end
end
