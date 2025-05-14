require 'spec_helper'

RSpec.describe BillingMachine::ProductBundle do
  let(:sale_tax_rate) { 0.1 }
  let(:import_tax_rate) { 0.05 }

  let(:product) do
    BillingMachine::Product.new(
      name: 'music CD',
      price: 14.99,
      sale_tax_rate: sale_tax_rate,
      import_tax_rate: import_tax_rate
    )
  end

  context 'when creating a bundle of regular products' do
    let(:quantity) { 3 }

    subject do
      described_class.new(
        product: product,
        quantity: quantity
      )
    end

    it 'calculates total price as product total_price times quantity' do
      expect(subject.total_price).to eq(product.total_price * quantity)
    end

    it 'calculates total tax as product total_tax times quantity' do
      expect(subject.total_tax).to eq(product.total_tax * quantity)
    end

    it 'returns a correct string representation' do
      expect(subject.to_billing_line).to eq('3 music CD: 49.47')
    end
  end

  context 'when quantity is 1' do
    subject do
      described_class.new(
        product: product,
        quantity: 1
      )
    end

    it 'returns the same total price as the product' do
      expect(subject.total_price).to eq(product.total_price)
    end

    it 'returns the same total tax as the product' do
      expect(subject.total_tax).to eq(product.total_tax)
    end

    it 'returns a correct string representation' do
      expect(subject.to_billing_line).to eq('1 music CD: 16.49')
    end
  end

  context 'when bundling an imported exempt product' do
    let(:quantity) { 2 }

    let(:imported_chocolate) do
      BillingMachine::Product.new(
        name: 'imported box of chocolates',
        price: 10.00,
        sale_tax_rate: sale_tax_rate,
        import_tax_rate: import_tax_rate
      )
    end

    subject do
      described_class.new(
        product: imported_chocolate,
        quantity: quantity
      )
    end

    it 'calculates total price and tax correctly' do
      expect(subject.total_tax).to eq(imported_chocolate.total_tax * quantity)
      expect(subject.total_price).to eq(imported_chocolate.total_price * quantity)
      expect(subject.to_billing_line).to eq('2 imported box of chocolates: 21.00')
    end
  end
end
