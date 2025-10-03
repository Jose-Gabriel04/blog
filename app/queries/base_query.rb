# frozen_string_literal: true

class BaseQuery
  def initialize(params = {})
    @params = params
  end

  def call
    raise MethodNotImplementedError, ':call'
  end
end
