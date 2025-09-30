# frozen_string_literal: true

class PostForm < BaseForm
  attr_accessor :user_login

  attribute :title, :string
  attribute :body, :string
  attribute :ip, :string

  validate :presence_of_user_login
  validates :title, :body, :ip, presence: true

  private

  def default_record
    Post.new
  end

  def attributes_for_creation
    { user_id:, title:, body:, ip: }
  end

  def user_id
    User.find_or_create_by(login: user_login).id if user_login.present?
  end

  def presence_of_user_login
    errors.add(:user_login, :blank) if user_login.blank?
  end
end
