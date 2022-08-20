require_relative '../../spec_helper'

describe Lambda::NamedExpression::Tokens::Tokenizer do
  describe '#tokenize_expression' do
    subject do
      described_class.tokenize_expression(expression).map do |token|
        [token.type, token.symbol]
      end
    end

    shared_examples 'recognision' do
      it 'recognizes the tokens' do
        expect(subject).to eq(expected_result)
      end
    end

    context 'with end of expression' do
      let(:expression) { '' }
      let(:expected_result) { [[:end, '|']] }

      it_behaves_like 'recognision'
    end

    context 'with empty spaces' do
      let(:expression) { '     ' }
      let(:expected_result) { [[:end, '|']] }

      it_behaves_like 'recognision'
    end

    context 'with brackets' do
      let(:expression) { '()' }
      let(:expected_result) { [[:open_bracket, '('], [:closed_bracket, ')'], [:end, '|']] }

      it_behaves_like 'recognision'
    end

    context 'with square brackets' do
      let(:expression) { '[]' }
      let(:expected_result) { [[:open_square_bracket, '['], [:closed_square_bracket, ']'], [:end, '|']] }

      it_behaves_like 'recognision'
    end

    context 'with lambda symbols' do
      let(:expression) { '^' }
      let(:expected_result) { [[:lambda, '^'], [:end, '|']] }

      it_behaves_like 'recognision'
    end

    context 'with dots' do
      let(:expression) { '.' }
      let(:expected_result) { [[:dot, '.'], [:end, '|']] }

      it_behaves_like 'recognision'
    end

    context 'with dashes' do
      let(:expression) { '-' }
      let(:expected_result) { [[:dash, '-'], [:end, '|']] }

      it_behaves_like 'recognision'
    end

    context 'with arrows' do
      let(:expression) { '>' }
      let(:expected_result) { [[:arrow, '>'], [:end, '|']] }

      it_behaves_like 'recognision'
    end

    context 'with latin letters' do
      let(:expression) { 'abcdefghijklmnopqrstuvwxyz' }
      let(:expected_result) do
        [
          [:variable, 'a'],
          [:variable, 'b'],
          [:variable, 'c'],
          [:variable, 'd'],
          [:variable, 'e'],
          [:variable, 'f'],
          [:variable, 'g'],
          [:variable, 'h'],
          [:variable, 'i'],
          [:variable, 'j'],
          [:variable, 'k'],
          [:variable, 'l'],
          [:variable, 'm'],
          [:variable, 'n'],
          [:variable, 'o'],
          [:variable, 'p'],
          [:variable, 'q'],
          [:variable, 'r'],
          [:variable, 's'],
          [:variable, 't'],
          [:variable, 'u'],
          [:variable, 'v'],
          [:variable, 'w'],
          [:variable, 'x'],
          [:variable, 'y'],
          [:variable, 'z'],
          [:end, '|']
        ]

        it_behaves_like 'recognision'
      end
    end

    context 'with unrecognized characters' do
      let(:recognized_symbols) do
        [' ', '(', ')', '[', ']', '^', '.', '-', '>', *('a'..'z').to_a]
      end

      it 'raises an error' do
        (ASCII_CHARACTERS - recognized_symbols).each do |expression|
          expect { described_class.tokenize_expression(expression) }.to raise_error(Lambda::NamedExpression::Tokens::NamedExpressionTokenizerException, "FATAL: invalid token #{expression}")
        end
      end
    end
  end
end
