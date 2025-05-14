# frozen_string_literal: true

module BillingMachine
  class ProductBundle
    def initialize(product:, quantity:)
      @product = product
      @quantity = quantity
    end

    def total_price
      @product.total_price * @quantity
    end

    def total_tax
      @product.total_tax * @quantity
    end

    def to_billing_line
      "#{@quantity} #{@product.name}: #{format('%.2f', total_price)}"
    end
  end
end
