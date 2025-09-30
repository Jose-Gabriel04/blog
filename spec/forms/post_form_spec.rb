# frozen_string_literal: true

RSpec.describe PostForm do
  subject(:form) { described_class.new(attributes:) }

  describe 'validations' do
    context 'when :title is empty' do
      let(:attributes) { { title: nil } }

      it 'is invalid' do
        expect(form).not_to be_valid
        expect(form.errors[:title]).to include("can't be blank")
      end
    end

    context 'when :body is empty' do
      let(:attributes) { { body: nil } }

      it 'is invalid' do
        expect(form).not_to be_valid
        expect(form.errors[:body]).to include("can't be blank")
      end
    end

    context 'when :ip is empty' do
      let(:attributes) { { ip: nil } }

      it 'is invalid' do
        expect(form).not_to be_valid
        expect(form.errors[:ip]).to include("can't be blank")
      end
    end

    context 'when :user_login is empty' do
      let(:attributes) { { user_login: nil } }

      it 'is invalid' do
        expect(form).not_to be_valid
        expect(form.errors[:user_login]).to include("can't be blank")
      end
    end
  end

  describe '#save' do
    let(:attributes) do
      {
        title: 'Test title',
        body: 'Test body',
        ip: '127.0.0.1',
        user_login: 'test_user_login'
      }
    end

    let(:post) { form.record }

    it 'save with valid attributes' do
      expect(form.save).to be_truthy
      expect(post.title).to eq('Test title')
      expect(post.body).to eq('Test body')
      expect(post.ip).to eq('127.0.0.1')
      expect(post.user.login).to eq('test_user_login')
    end

    context 'when user is persisted' do
      let(:user) { create(:user, login: 'persisted_login') }
      let(:attributes) do
        {
          title: 'Test title',
          body: 'Test body',
          ip: '127.0.0.1',
          user_login: user.login
        }
      end

      before { create(:user) }

      it 'save with valid attributes and return persisted user_id' do
        expect(form.save).to be_truthy
        expect(post.title).to eq('Test title')
        expect(post.body).to eq('Test body')
        expect(post.ip).to eq('127.0.0.1')
        expect(post.user_id).to eq(user.id)
        expect(post.user.login).to eq('persisted_login')
      end
    end
  end
end
