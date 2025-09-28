# frozen_string_literal: true

class Post < ApplicationRecord
  belongs_to :user

  validates :title, :body, :ip, presence: true
end
