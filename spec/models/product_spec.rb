require 'spec_helper'

RSpec.describe BillingMachine::Product do
  let(:sale_tax_rate) { 0.1 }
  let(:import_tax_rate) { 0.05 }

  context 'when the product is a regular (non-imported, non-exempt) item' do
    subject do
      described_class.new(
        name: 'music CD', price: 14.99,
        sale_tax_rate: sale_tax_rate,
        import_tax_rate: import_tax_rate
      )
    end

    it 'applies only the sales tax' do
      expect(subject.total_tax).to eq(1.50)
      expect(subject.total_price.to_f).to eq(16.49)
    end
  end

  context 'when the product is exempt (book)' do
    subject do
      described_class.new(
        name: 'book',
        price: 12.49,
        sale_tax_rate: sale_tax_rate,
        import_tax_rate: import_tax_rate
      )
    end

    it 'applies no tax' do
      expect(subject.total_tax).to eq(0.0)
      expect(subject.total_price.to_f).to eq(12.49)
    end
  end

  context 'when the product is imported and not exempt' do
    subject do
      described_class.new(
        name: 'imported bottle of perfume',
        price: 27.99,
        sale_tax_rate: sale_tax_rate,
        import_tax_rate: import_tax_rate
      )
    end

    it 'applies both sales and import taxes, rounded up to the nearest 0.05' do
      expect(subject.total_tax).to eq(4.20)
      expect(subject.total_price).to eq(32.19)
    end
  end

  context 'when the product is imported and exempt' do
    subject do
      described_class.new(
        name: 'imported box of chocolates',
        price: 10.00,
        sale_tax_rate: sale_tax_rate,
        import_tax_rate: import_tax_rate
      )
    end

    it 'applies only the import tax' do
      expect(subject.total_tax).to eq(0.50)
      expect(subject.total_price).to eq(10.50)
    end
  end

  context 'when tax needs to be rounded up to the nearest 0.05' do
    subject do
      described_class.new(
        name: 'music CD',
        price: 14.99,
        sale_tax_rate: 0.133,
        import_tax_rate: 0.0
      )
    end

    it 'rounds the tax up to the next 0.05' do
      # 14.99 * 0.133 = 1.98867 -> rounds up to 2.00
      expect(subject.total_tax).to eq(2.00)
      expect(subject.total_price).to eq(16.99)
    end
  end
end
