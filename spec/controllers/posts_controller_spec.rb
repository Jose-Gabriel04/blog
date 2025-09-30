# frozen_string_literal: true

RSpec.describe PostsController do
  describe 'POST #create' do
    context 'when requests with valid params' do
      let(:valid_params) do
        { title: 'Test post', body: 'Test body', user_login: 'user_login', ip: '127.0.0.1' }
      end

      it 'create a new post, return sucess status and response includes posts and user attrs' do
        expect { post :create, params: valid_params }.to change(Post, :count).by(1)
        expect(response).to have_http_status(:created)
        json_response = response.parsed_body
        expect(json_response).to include(id: 1, title: 'Test post', body: 'Test body')
        expect(json_response[:user]).to include(id: 1, login: 'user_login')
        expect(json_response).to have_key(:created_at)
        expect(json_response).to have_key(:updated_at)
      end
    end

    context 'when requests with invalid params' do
      let(:invalid_params) { { title: 'Test post', body: 'Test body', ip: '127.0.0.1' } }

      it 'dont create a new post and return errors message' do
        expect { post :create, params: invalid_params }.not_to change(Post, :count)

        expect(response).to have_http_status(:unprocessable_content)
        expect(response.parsed_body).to eq({ 'errors' => ["User login can't be blank"] })
      end
    end
  end
end
