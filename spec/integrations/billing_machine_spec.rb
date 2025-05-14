require 'spec_helper'
require_relative '../../lib/billing_machine'

RSpec.describe BillingMachine do
  describe '#call integration test' do
    let(:input_1) do
      <<~CSV
        2,book,12.49
        1,music CD,14.99
        1,chocolate bar,0.85
      CSV
    end

    let(:expected_output_1) do
      <<~OUT
        2 book: 24.98
        1 music CD: 16.49
        1 chocolate bar: 0.85
        Sales Taxes: 1.50
        Total: 42.32
      OUT
    end

    let(:input_2) do
      <<~CSV
        1,imported box of chocolates,10.00
        1,imported bottle of perfume,47.50
      CSV
    end

    let(:expected_output_2) do
      <<~OUT
        1 imported box of chocolates: 10.50
        1 imported bottle of perfume: 54.65
        Sales Taxes: 7.65
        Total: 65.15
      OUT
    end

    let(:input_3) do
      <<~CSV
        1,imported bottle of perfume,27.99
        1,bottle of perfume,18.99
        1,packet of headache pills,9.75
        3,imported boxes of chocolates,11.25
      CSV
    end

    let(:expected_output_3) do
      <<~OUT
        1 imported bottle of perfume: 32.19
        1 bottle of perfume: 20.89
        1 packet of headache pills: 9.75
        3 imported boxes of chocolates: 35.55
        Sales Taxes: 7.90
        Total: 98.38
      OUT
    end

    it 'prints correct receipts for inputs' do
      expect { BillingMachine.call(input_1) }.to output(expected_output_1).to_stdout
      expect { BillingMachine.call(input_2) }.to output(expected_output_2).to_stdout
      expect { BillingMachine.call(input_3) }.to output(expected_output_3).to_stdout
    end
  end
end
