module Api
  class ItemsController < ApplicationController
    before_action :get_todo_list, only: [:index, :create]

    def index
      @items = @todo_list.items

      respond_to :json
    end

    def create
      item = Item.new(item_params)
      item.todo_list = @todo_list
      item.save

      if item.valid?
        render_success('Se creó el item')
      else
        render_error(item.errors.full_messages.join)
      end
    end

    private

    def item_params
      params.require(:item).permit(:name)
    end

    def get_todo_list
      begin
        @todo_list = TodoList.find(params[:todo_list_id])
      rescue => error
        render_error(error.message)
      end
    end
  end
end
