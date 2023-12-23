module Api
  class TodoListsController < ApplicationController
    # GET /api/todolists
    def index
      @todo_lists = TodoList.all

      respond_to :json
    end

    def create
      @todo_list = TodoList.new(todo_params)
      @todo_list.user = @current_user

      begin
        @todo_list.save!
      rescue StandardError => error
        render json: { message: error.message }
      end

      respond_to :json
    end

    def show
      begin
        @todo_list = TodoList.find(params[:id])

        respond_to :json
      rescue ActiveRecord::RecordNotFound => error
        render json: { message: 'No se encontró el registro' }
      rescue StandardError => error
        render json: { message: 'Ocurrió un error' }, status: :unprocessable_entity
      end
    end

    def destroy
      begin
        @todo_list = TodoList.find(params[:id])

        @todo_list.destroy
        render json: { message: 'Eliminación exitosa' }
      rescue StandardError => error
        render json: { error: 'Ocurrió un error durante la eliminación' }, status: :unprocessable_entity
      end
    end

    private

    def todo_params
      params.require(:todo_list).permit(:name)
    end
  end
end
