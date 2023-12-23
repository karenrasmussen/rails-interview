module Api
  class UsersController < ApplicationController
    def index
      @users = User.all

      respond_to :json
    end

    def create
      @user = User.new(user_params)

      begin
        @user.save!
        render :show
      rescue StandardError => error
        render json: { message: 'No se pudo crear el usuario' }
      end
    end

    def show
      @user = User.find(params[:id])

      respond_to :json
    end

    def destroy
      begin
        user = User.find(params[:id])
        user.destroy!
        render json: { message: 'Eliminación exitosa'}
      rescue StandardError => error
        render json: {message: 'Ocurrió un error durante la eliminación'}
      end
    end

    def login
      user = User.find_by(email: params[:email])

      if user && user.authenticate(params[:password])
        session[:user_id] = user.id
        render json: { message: 'Inicio de sesión exitoso' }
      else
        render json: { message: 'Credenciales inválidas' }
      end
    end

    def logout
      session[:user_id] = nil
      render json: { message: 'Logout' }
    end

    private

    def user_params
      params.require(:user).permit(:name, :email, :password)
    end
  end
end
