# frozen_string_literal: true

require_relative '../config/app'

module BillingMachine

  def self.call(scv_data)
    BillingService.call(scv_data)
  end
end
