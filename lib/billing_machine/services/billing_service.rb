# frozen_string_literal: true

module BillingMachine
  class BillingService < BaseService
    SALES_TAX_RATE = 0.1
    IMPORT_TAX_RATE = 0.05

    def initialize(csv_data)
      @csv_data = csv_data
      @products_bundles = []
    end

    def call
      parse_csv
      print_receipt
    end

    private

    def parse_csv
      CSV.parse(@csv_data, headers: false) do |row|
        quantity = row[0].to_i

        @products_bundles <<
          BillingMachine::ProductBundle.new(
            quantity: quantity,
            product: product_by(row)
          )
      end
    end

    def product_by(row)
      BillingMachine::Product.new(
        name: row[1],
        price: row[2],
        sale_tax_rate: SALES_TAX_RATE,
        import_tax_rate: IMPORT_TAX_RATE
      )
    end

    def print_receipt
      @products_bundles.each do |product_bundle|
        puts product_bundle.to_billing_line
      end

      sales_tax = @products_bundles.sum(&:total_tax)
      puts "Sales Taxes: #{'%.2f' % sales_tax}"
      total = @products_bundles.sum(&:total_price)
      puts "Total: #{'%.2f' % total}"
    end
  end
end
