require 'rails_helper'

describe Api::TodoListsController do
  render_views

  let!(:user) { User.create(name: 'User', email: 'user@email.com', password: 'password') }

  describe 'GET index' do
    let!(:todo_list) { TodoList.create(name: 'Setup RoR project', user: user) }

    context 'when format is HTML' do
      it 'raises a routing error' do
        expect {
          get :index
        }.to raise_error(ActionController::RoutingError, 'Not supported format')
      end
    end

    context 'when format is JSON' do
      it 'returns a success code' do
        get :index, format: :json

        expect(response.status).to eq(200)
      end

      it 'includes todo list records' do
        get :index, format: :json

        todo_lists = JSON.parse(response.body)

        aggregate_failures 'includes the id and name' do
          expect(todo_lists.count).to eq(1)
          expect(todo_lists[0].keys).to match_array(['id', 'name'])
          expect(todo_lists[0]['id']).to eq(todo_list.id)
          expect(todo_lists[0]['name']).to eq(todo_list.name)
        end
      end
    end
  end

  describe 'POST create' do
    let(:valid_params) { { todo_list: { name: 'New Todo List' }, format: :json } }

    before do
      session[:user_id] = user.id
    end

    context 'with valid parameters' do
      it 'creates a new todo_list' do
        expect {
          post :create, params: valid_params
        }.to change(TodoList, :count).by(1)
      end

      it 'returns a success code' do
        post :create, params: valid_params

        expect(response.status).to eq(200)
      end
    end
  end

  let!(:todo_list) { TodoList.create(name: 'Setup RoR project', user: user) }

  describe 'GET show' do
    context 'when format is JSON' do
      it 'returns a success code' do
        get :show, params: { id: todo_list.id, format: :json }

        expect(response.status).to eq(200)
      end

      it 'renders JSON representation of the todo_list' do
        get :show, params: { id: todo_list.id, format: :json }
        todo_list_json = JSON.parse(response.body)

        aggregate_failures 'includes the expected attributes' do
          expect(todo_list_json.keys).to match_array(['id', 'name', 'user_email'])
          expect(todo_list_json['id']).to eq(todo_list.id)
          expect(todo_list_json['name']).to eq(todo_list.name)
          expect(todo_list_json['user_email']).to eq(todo_list.user.email)
        end
      end
    end
  end

  describe 'DELETE destroy' do
    context 'when destroy is successful' do
      it 'destroys the todo_list' do
        delete :destroy, params: { id: todo_list.id, format: :json }

        expect(response.status).to eq(200)
        expect(TodoList.find_by(id: todo_list.id)).to be_nil
      end
    end

    context 'when an error occurs during destroy' do
      it 'renders an error message' do
        delete :destroy, params: { id: 2, format: :json }

        json_response = JSON.parse(response.body)
        expect(json_response['message']).to eq("Couldn't find TodoList with 'id'=2")
      end
    end
  end
end
