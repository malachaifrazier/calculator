require 'spec_helper'
require 'pry'

describe Calculator do
  before do
    @evaluator = Calculator::CLI.new
  end

  context 'without prompt addition' do
    describe 'addition passes for' do
      it 'two integers' do
        expect(@evaluator.evaluate_string ['10', '+', '20']).to eq 30
      end

      it 'an integer and a float' do
        expect(@evaluator.evaluate_string ['10.5', '+', '2']).to eq 12.5
      end

      it 'three integers' do
        expect(@evaluator.count_operators ['10', '+', '20', '+', '30']).to eq 60
      end

      it 'multiple integers & float' do
        expect(@evaluator.count_operators ['10', '+', '2', '+', '30', '+', '22.0028']).to eq 64.00280000000001
      end
    end

    describe 'subtraction passes for' do
      it 'two integers' do
        expect(@evaluator.evaluate_string ['10', '-', '22']).to eq -12
      end

      it 'an integer and a float' do
        expect(@evaluator.evaluate_string ['10.5', '-', '2']).to eq 8.5
      end

      it 'three integers' do
        expect(@evaluator.count_operators ['10', '-', '2', '-', '4']).to eq 4
        expect(@evaluator.count_operators ['10', '-', '20', '-', '30']).to eq -40
      end
    end

    describe 'multiplification passes for' do
      it 'two integers' do
        expect(@evaluator.evaluate_string ['10', '*', '2']).to eq 20
      end

      it 'an integer and a float' do
        expect(@evaluator.evaluate_string ['1.5', '*', '2.9814']).to eq 4.472099999999999
      end

      it 'three integers' do
        expect(@evaluator.count_operators ['10', '*', '2', '*', '5']).to eq 100
      end
    end

    describe 'PEMDAS passes for' do
      it 'three integers and two operators' do
        expect {
          @evaluator.count_operators ['2', '+', '3', '/', '5']
        }.to output("2\n").to_stdout

        expect {
          @evaluator.count_operators ['20', '+', '10', '/', '100']
        }.to output("20\n").to_stdout

        expect {
          @evaluator.count_operators ['8.10', '-', '2.330', '/', '820']
        }.to output("8.097158536585365\n").to_stdout
      end

      it 'four integers, two operators and a float' do
        expect {
          @evaluator.count_operators ['20', '*', '2.9814', '-', '2.022', '/', '2']
        }.to output("58.617\n").to_stdout
      end
    end
  end

  # 2 + 3 / 5
  # 8.10 - 2.330 / 820
  # 20 * 2.9814 - 2.022 / 2

end