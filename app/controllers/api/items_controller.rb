module Api
  class ItemsController < ApplicationController
    before_action :get_todo_list

    def index
      @items = @todo_list.items

      respond_to :json
    end

    def create
      item = Item.new(item_params)
      item.todo_list = @todo_list
      item.save

      if item.valid?
        render json: { message: 'Se creó el item' }
      else
        render json: { message: item.errors.full_messages.join }
      end
    end

    private

    def item_params
      params.require(:item).permit(:name)
    end

    def get_todo_list
      todo_list_id = params[:todo_list_id]
      @todo_list = TodoList.find(todo_list_id)
    end
  end
end
