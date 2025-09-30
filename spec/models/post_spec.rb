# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Post, type: :model do
  describe 'database' do
    it { is_expected.to have_db_column(:user_id).of_type(:integer).with_options(null: false) }

    it { is_expected.to have_db_column(:title).of_type(:string).with_options(null: false) }
    it { is_expected.to have_db_column(:body).of_type(:text).with_options(null: false) }
    it { is_expected.to have_db_column(:ip).of_type(:string).with_options(null: false) }

    it { is_expected.to have_db_column(:created_at).of_type(:datetime).with_options(null: false) }
    it { is_expected.to have_db_column(:updated_at).of_type(:datetime).with_options(null: false) }

    it { is_expected.to have_db_index(:user_id) }
    it { is_expected.to have_db_index(:ip) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:body) }
    it { is_expected.to validate_presence_of(:ip) }
  end
end
