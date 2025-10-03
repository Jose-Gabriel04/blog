# frozen_string_literal: true

class SharedIpsQuery < BaseQuery
  def call
    Post.joins(:user)
        .group('ip')
        .having('COUNT(DISTINCT users.id) > 1')
        .select('ip, array_agg(DISTINCT users.login) as authors_logins')
  end
end
