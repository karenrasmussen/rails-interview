require 'rails_helper'

describe Api::UsersController do
  render_views

  let!(:user) { User.create(name: 'User', email: 'user@email.com', password: 'password') }

  describe 'GET index' do
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

      it 'includes user records' do
        get :index, format: :json
        users = JSON.parse(response.body)

        aggregate_failures 'includes the id and name' do
          expect(users.count).to eq(1)
          expect(users[0].keys).to match_array(['id', 'name', 'email'])
          expect(users[0]['id']).to eq(user.id)
          expect(users[0]['name']).to eq(user.name)
          expect(users[0]['email']).to eq(user.email)
        end
      end
    end
  end

  describe 'POST create' do
    let(:valid_params) { { user: { name: 'New User', email: 'new_user@email.com', password: 'password' }, format: :json } }

    context 'with valid parameters' do
      it 'creates a new user' do
        expect {
          post :create, params: valid_params
        }.to change(User, :count).by(1)
      end

      it 'returns a success code' do
        post :create, params: valid_params

        expect(response.status).to eq(200)
      end
    end
  end

  describe 'GET show' do
    context 'when format is JSON' do
      it 'returns a success code' do
        get :show, params: { id: user.id, format: :json }

        expect(response.status).to eq(200)
      end

      it 'renders JSON representation of the user' do
        get :show, params: { id: user.id, format: :json }
        user_json = JSON.parse(response.body)

        aggregate_failures 'includes the expected attributes' do
          expect(user_json['id']).to eq(user.id)
          expect(user_json['name']).to eq(user.name)
        end
      end
    end
  end

  describe 'DELETE destroy' do
    context 'when destroy is successful' do
      it 'destroys the user' do
        delete :destroy, params: { id: user.id, format: :json }

        expect(response.status).to eq(200)
        expect(User.find_by(id: user.id)).to be_nil
      end
    end

    context 'when an error occurs during destroy' do
      it 'renders an error message' do
        delete :destroy, params: { id: 3, format: :json }

        json_response = JSON.parse(response.body)
        expect(json_response['message']).to eq("Couldn't find User with 'id'=3")
      end
    end
  end

  describe 'POST login' do
    context 'with valid credentials' do
      it 'logs in the user and renders a success message' do
        post :login, params: { email: user.email, password: 'password' }

        expect(session[:user_id]).to eq(user.id)
        expect(response.status).to eq(200)
        expect(JSON.parse(response.body)['message']).to eq('Inicio de sesión exitoso')
      end
    end

    context 'with invalid credentials' do
      it 'does not log in the user and renders an error message' do
        post :login, params: { email: user.email, password: 'wrong_password' }

        expect(session[:user_id]).to be_nil
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['message']).to eq('Credenciales inválidas')
      end
    end
  end

  describe 'POST logout' do
    before do
      session[:user_id] = user.id
    end

    it 'logs out the user and renders a success message' do
      delete :logout

      expect(session[:user_id]).to be_nil
      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)['message']).to eq('Logout')
    end
  end
end
