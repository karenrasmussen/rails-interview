class TodoListsController < ApplicationController
  # GET /todolists
  def index
    @todo_lists = TodoList.all

    respond_to :html
  end

  # GET /todolists/new
  def new
    @todo_list = TodoList.new

    respond_to :html
  end

  def create
    @todo_list = TodoList.new(todo_params)

    if @todo_list.save
      redirect_to @todo_list, notice: 'Todo creado exitosamente.'
    else
      render :new
    end
  end

  def show
    @todo_list = TodoList.find(params[:id])

    respond_to :html
  end

  private

  def todo_params
    params.require(:todo_list).permit(:name)
  end
end
