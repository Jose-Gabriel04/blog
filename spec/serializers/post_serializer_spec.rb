# frozen_string_literal: true

RSpec.describe PostSerializer do
  describe '#as_json' do
    context 'when context: :post' do
      subject(:serializer) { described_class.new(post, context: :post) }

      let(:user) { create(:user, id: 1, login: 'john_doe') }
      let(:post) do
        create(:post, id: 1, title: 'Test Title', body: 'Test Body', user: user,
                      created_at: Time.zone.parse('2025-09-30 10:00:00 UTC'),
                      updated_at: Time.zone.parse('2025-09-30 11:00:00 UTC'))
      end

      it 'includes serialized post' do
        result = serializer.as_json

        expect(result[:id]).to eq(1)
        expect(result[:title]).to eq('Test Title')
        expect(result[:body]).to eq('Test Body')
        expect(result[:created_at]).to eq(post.created_at)
        expect(result[:updated_at]).to eq(post.updated_at)
      end

      it 'includes serialized user' do
        result = serializer.as_json

        expect(result[:user]).to be_a(Hash)
        expect(result[:user][:id]).to eq(1)
        expect(result[:user][:login]).to eq('john_doe')
      end
    end

    context 'when context: :top' do
      subject(:serializer) { described_class.new(post, context: :top) }

      let(:post) { create(:post, id: 1, body: 'Test Body', average_rating: 5.0) }

      it 'includes serialized post' do
        result = serializer.as_json

        expect(result[:id]).to eq(1)
        expect(result[:body]).to eq('Test Body')
        expect(result[:average_rating]).to eq(5.0)
      end
    end

    context 'when context: :shared_ips' do
      subject(:serializer) { described_class.new(post_data, context: :shared_ips) }

      let(:post_data) do
        Struct.new(:id, :ip, :authors_logins, keyword_init: true).new(
          id: 1,
          ip: '127.0.0.1',
          authors_logins: ['user_login1']
        )
      end

      it 'includes serialized post' do
        result = serializer.as_json

        expect(result[:ip]).to eq('127.0.0.1')
        expect(result[:authors]).to eq(['user_login1'])
      end
    end
  end
end
