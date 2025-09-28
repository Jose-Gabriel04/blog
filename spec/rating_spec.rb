# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Rating, type: :model do
  subject { create(:rating) }

  describe 'database' do
    it { is_expected.to have_db_column(:post_id).of_type(:integer).with_options(null: false) }
    it { is_expected.to have_db_column(:user_id).of_type(:integer).with_options(null: false) }
    it { is_expected.to have_db_column(:value).of_type(:integer).with_options(null: false) }

    it { is_expected.to have_db_column(:created_at).of_type(:datetime).with_options(null: false) }
    it { is_expected.to have_db_column(:updated_at).of_type(:datetime).with_options(null: false) }

    it { is_expected.to have_db_index(%i[post_id user_id]).unique(true) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:post) }
    it { is_expected.to belong_to(:user) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:value) }
    it { is_expected.to validate_uniqueness_of(:user_id).scoped_to(:post_id) }
  end
end
