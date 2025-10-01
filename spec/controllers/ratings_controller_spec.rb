# frozen_string_literal: true

RSpec.describe RatingsController do
  describe 'POST #create' do
    let(:user) { create(:user) }
    let(:post_record) { create(:post, user:) }

    context 'when requests with valid params' do
      let(:valid_params) { { post_id: post_record.id, user_id: user.id, value: 5 } }

      it 'create a new rating, return sucess status and response includes id and average_rating' do
        expect { post :create, params: valid_params }.to change(Rating, :count).by(1)
        expect(response).to have_http_status(:created)
        json_response = response.parsed_body
        expect(json_response).to include(id: 1, average_rating: 5.0)
      end
    end

    context 'when requests with invalid params' do
      let(:invalid_params) { { post_id: post_record.id, user_id: user.id } }

      it 'dont create a new rating and return errors message' do
        expect { post :create, params: invalid_params }.not_to change(Rating, :count)

        expect(response).to have_http_status(:unprocessable_content)
        expect(response.parsed_body).to eq({ 'errors' => ["Value can't be blank"] })
      end
    end
  end
end
