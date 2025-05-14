# frozen_string_literal: true

module BillingMachine
  class Product
    EXEMPT_PRODUCTS = %w[book chocolate pill].freeze
    IMPORTED_PRODUCTS = ['imported'].freeze

    def initialize(name:, price:, sale_tax_rate:, import_tax_rate:)
      @name = name
      @price = price.to_d
      @sale_tax_rate = sale_tax_rate
      @import_tax_rate = import_tax_rate
    end

    attr_reader :name, :price

    def total_price
      (@price + total_tax)
    end

    def total_tax
      tax = 0.0
      tax += @price * @sale_tax_rate unless exempt_product?
      tax += @price * @import_tax_rate if imported_product?
      round_up_to_0_05(tax)
    end

    private

    def imported_product?
      IMPORTED_PRODUCTS.any? { |key_word| @name.downcase.include?(key_word) }
    end

    def exempt_product?
      EXEMPT_PRODUCTS.any? { |key_word| @name.downcase.include?(key_word) }
    end

    def round_up_to_0_05(amount)
      ((amount / 0.05).ceil * 0.05).round(2)
    end
  end
end
