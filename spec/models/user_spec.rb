# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User do
  subject { build(:user) }

  describe 'database' do
    it { is_expected.to have_db_column(:login).of_type(:string).with_options(null: false) }

    it { is_expected.to have_db_column(:created_at).of_type(:datetime).with_options(null: false) }
    it { is_expected.to have_db_column(:updated_at).of_type(:datetime).with_options(null: false) }

    it { is_expected.to have_db_index(:login).unique(true) }
  end

  describe 'associations' do
    it { is_expected.to have_many(:posts).dependent(:destroy) }
    it { is_expected.to have_many(:ratings).dependent(:destroy) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:login) }
    it { is_expected.to validate_uniqueness_of(:login) }
  end
end
