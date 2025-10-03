# frozen_string_literal: true

RSpec.describe SharedIpsQuery do
  subject(:query) { described_class.new }

  describe 'call' do
    let(:user_one) { create(:user, login: 'user_one') }
    let(:user_two) { create(:user, login: 'user_two') }
    let(:user_three) { create(:user, login: 'user_three') }

    before do
      create(:post, user: user_one, ip: '127.0.0.0')
      create(:post, user: user_two, ip: '127.0.0.0')
      create(:post, user: user_one, ip: '127.0.0.1')
      create(:post, user: user_three, ip: '127.0.0.1')
      create(:post, user: user_two, ip: '127.0.0.2')
    end

    it 'returns IPs shared by multiple authors with their logins' do
      result = query.call

      expect(result).to be_a(ActiveRecord::Relation)
      expect(result.length).to eq(2)
      ips_data = result.map do |record|
        {
          'ip' => record.ip,
          'authors' => record.authors_logins.sort
        }
      end

      expect(ips_data)
        .to contain_exactly({ 'ip' => '127.0.0.0', 'authors' => %w[user_one user_two] },
                            { 'ip' => '127.0.0.1', 'authors' => %w[user_one user_three] })
    end
  end
end
