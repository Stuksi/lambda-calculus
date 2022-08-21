require_relative '../../spec_helper'

describe Lambda::NamelessExpression::Terms::VariableTerm do
  subject { described_class.new(symbol) }

  describe '#initialize' do
    context 'with unrecognized symbols' do
      it 'raises an error' do
        (ASCII_CHARACTERS - ('0'..'9').to_a).each do |symbol|
          expect { described_class.new(symbol) }.to raise_error(
            Lambda::NamedExpression::Terms::VariableTermException,
            "FATAL: invalid variable symbol #{symbol}"
          )
        end
      end
    end
  end

  describe '#offset' do
    context 'with variable in critical section' do
      let(:symbol) { 0 }

      it 'preserves the variable' do
        expect(subject.offset(1, 1)).to eq(subject)
      end
    end

    context 'with variable outside critical section' do
      let(:symbol) { 0 }

      it 'preserves the variable' do
        expect(subject.offset(0, 1)).to eq(described_class.new(1))
      end

      it 'raises an error on offset overflow' do
        expect { subject.offset(0, 10) }.to raise_error(
          Lambda::NamelessExpression::Terms::VariableTermException,
          'FATAL: offset overflow'
        )
      end
    end
  end
end
