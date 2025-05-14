# frozen_string_literal: true

module BillingMachine
  class BaseService
    class << self
      def call(*args, **kwargs)
        new(*args, **kwargs).call
      end
    end
  end
end
