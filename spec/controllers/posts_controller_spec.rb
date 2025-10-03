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

  describe 'GET #top' do
    let(:parsed_response) do
      [{ 'average_rating' => 5.0, 'body' => 'test_post_1', 'id' => 100 },
       { 'average_rating' => 4.5, 'body' => 'test_post_2', 'id' => 101 }]
    end

    before do
      create(:post, id: 100, body: 'test_post_1', average_rating: 5.0)
      create(:post, id: 101, body: 'test_post_2', average_rating: 4.5)
      create(:post, id: 102, body: 'test_post_3', average_rating: 4.0)
    end

    it 'get top N posts by average rating' do
      get :top, params: { limit: 2 }

      expect(response).to have_http_status(:ok)
      expect(response.parsed_body).to eq(parsed_response)
    end
  end

  describe 'GET #shared_ips' do
    let(:user_one) { create(:user, login: 'user_one') }
    let(:user_two) { create(:user, login: 'user_two') }
    let(:user_three) { create(:user, login: 'user_three') }
    let(:parsed_response) do
      [{ 'authors' => %w[user_one user_two], 'ip' => '127.0.0.0' },
       { 'authors' => %w[user_one user_three], 'ip' => '127.0.0.1' }]
    end

    before do
      create(:post, user: user_one, ip: '127.0.0.0')
      create(:post, user: user_two, ip: '127.0.0.0')
      create(:post, user: user_one, ip: '127.0.0.1')
      create(:post, user: user_three, ip: '127.0.0.1')
      create(:post, user: user_two, ip: '127.0.0.2')
    end

    it 'Get a list of IPs that were posted by several different authors' do
      get :shared_ips

      expect(response).to have_http_status(:ok)
      expect(response.parsed_body).to eq(parsed_response)
    end
  end
end
