require_relative '../../spec_helper'

describe Lambda::NamelessExpression::Tokens::Tokenizer do
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
      let(:expression) { '0123456789' }
      let(:expected_result) do
        [
          [:variable, '0'],
          [:variable, '1'],
          [:variable, '2'],
          [:variable, '3'],
          [:variable, '4'],
          [:variable, '5'],
          [:variable, '6'],
          [:variable, '7'],
          [:variable, '8'],
          [:variable, '9'],
          [:end, '|']
        ]

        it_behaves_like 'recognision'
      end
    end

    context 'with unrecognized characters' do
      let(:recognized_symbols) do
        [' ', '(', ')', '[', ']', '^', '-', '>', *('0'..'9').to_a]
      end

      it 'raises an error' do
        (ASCII_CHARACTERS - recognized_symbols).each do |expression|
          expect { described_class.tokenize_expression(expression) }.to raise_error(
            Lambda::NamelessExpression::Tokens::TokenizerException,
            "FATAL: invalid token #{expression}"
          )
        end
      end
    end
  end
end
