require 'spec_helper'

RSpec.describe BillingMachine::BillingService do
  describe '#parse_csv' do
    it 'parses CSV and fills @products_bundles with correct objects' do
      csv_data = <<~CSV
        2,book,12.49
        1,music CD,14.99
      CSV

      service = described_class.new(csv_data)
      service.send(:parse_csv)

      bundles = service.instance_variable_get(:@products_bundles)

      first_bundle = bundles[0]
      first_bundle_product = first_bundle.instance_variable_get(:@product)
      first_bundle_quantity = first_bundle.instance_variable_get(:@quantity)

      second_bundle = bundles[1]
      second_bundle_product = second_bundle.instance_variable_get(:@product)
      second_bundle_quantity = second_bundle.instance_variable_get(:@quantity)

      expect(bundles.size).to eq(2)
      expect(first_bundle).to be_a(BillingMachine::ProductBundle)
      expect(second_bundle).to be_a(BillingMachine::ProductBundle)
      expect(first_bundle_product).to be_a(BillingMachine::Product)
      expect(second_bundle_product).to be_a(BillingMachine::Product)
      expect(first_bundle_quantity).to eq(2)
      expect(second_bundle_quantity).to eq(1)
    end
  end

  it 'prints receipt in the correct format' do
    csv_data = <<~CSV
      2,book,12.49
      1,music CD,14.99
      1,chocolate bar,0.85
    CSV

    expected_output = <<~OUT
      2 book: 24.98
      1 music CD: 16.49
      1 chocolate bar: 0.85
      Sales Taxes: 1.50
      Total: 42.32
    OUT

    expect { described_class.call(csv_data) }.to output(expected_output).to_stdout
  end
end
