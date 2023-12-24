module Api
  class TodoListsController < ApplicationController
    before_action :get_todo_list, only: [:show, :destroy]

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
      rescue => error
        render_error(error.message)
      end

      respond_to :json
    end

    def show
      begin
        respond_to :json
      rescue => error
        render_error(error.message)
      end
    end

    def destroy
      begin
        @todo_list.destroy
        render_success('Eliminación exitosa')
      rescue => error
        render_error(error.message)
      end
    end

    private

    def todo_params
      params.require(:todo_list).permit(:name)
    end

    def get_todo_list
      begin
        @todo_list = TodoList.find(params[:id])
      rescue => error
        render_error(error.message)
      end
    end
  end
end
