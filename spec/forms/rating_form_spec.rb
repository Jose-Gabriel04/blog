# frozen_string_literal: true

RSpec.describe RatingForm do
  subject(:form) { described_class.new(attributes:) }

  describe 'validations' do
    context 'when :post_id is empty' do
      let(:attributes) { { post_id: nil } }

      it 'is invalid' do
        expect(form).not_to be_valid
        expect(form.errors[:post_id]).to include("can't be blank")
      end
    end

    context 'when :user_id is empty' do
      let(:attributes) { { user_id: nil } }

      it 'is invalid' do
        expect(form).not_to be_valid
        expect(form.errors[:user_id]).to include("can't be blank")
      end
    end

    context 'when :value is empty' do
      let(:attributes) { { value: nil } }

      it 'is invalid' do
        expect(form).not_to be_valid
        expect(form.errors[:value]).to include("can't be blank")
      end
    end

    context 'when :value is not included in 1..5' do
      let(:attributes) { { value: 6 } }

      it 'is invalid' do
        expect(form).not_to be_valid
        expect(form.errors[:value]).to include('is not included in the list')
      end
    end

    context 'when :post dont exists' do
      let(:attributes) { { post_id: 1, user_id: 1, value: 1 } }

      it 'is invalid' do
        expect(form).not_to be_valid
        expect(form.errors[:post_id]).to include('not found')
      end
    end

    context 'when :user dont exists' do
      let(:attributes) { { post_id: 1, user_id: 1, value: 1 } }

      it 'is invalid' do
        expect(form).not_to be_valid
        expect(form.errors[:user_id]).to include('not found')
      end
    end
  end

  describe '#save' do
    let(:user) { create(:user) }
    let(:post) { create(:post) }
    let(:attributes) do
      {
        post_id: post.id,
        user_id: user.id,
        value: 5
      }
    end

    let(:rating) { form.record }

    it 'save with valid attributes' do
      expect(form.save).to be_truthy
      expect(rating.post_id).to eq(post.id)
      expect(rating.user_id).to eq(user.id)
      expect(rating.value).to eq(5)
    end

    it 'increment post_average_rating and ratings_count' do
      form.save
      expect(post.reload.average_rating).to eq(5)
      expect(post.reload.ratings_count).to eq(1)
    end

    context 'when save raises ActiveRecord::RecordNotUnique' do
      before do
        allow_any_instance_of(BaseForm).to receive(:save).and_raise(ActiveRecord::RecordNotUnique)
      end

      it 'add error message and dont save rating' do
        expect(form.save).to be(false)
        expect(Rating.count).to eq(0)
        expect(form.errors[:base]).to include('You have already rated this post')
      end
    end
  end
end
