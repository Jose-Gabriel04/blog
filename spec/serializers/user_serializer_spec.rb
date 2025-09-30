# frozen_string_literal: true

RSpec.describe UserSerializer do
  describe '#as_json' do
    subject(:serializer) { described_class.new(user) }

    let(:user) do
      create(:user, id: 42, login: 'jane_doe',
                    created_at: Time.zone.parse('2025-09-30 09:00:00 UTC'))
    end

    it 'returns user attributes' do
      result = serializer.as_json

      expect(result).to be_a(Hash)
      expect(result[:id]).to eq(42)
      expect(result[:login]).to eq('jane_doe')
      expect(result[:created_at]).to eq(user.created_at)
    end

    it 'only includes id, login and created_at' do
      result = serializer.as_json

      expect(result.keys).to contain_exactly(:id, :login, :created_at)
    end
  end
end
