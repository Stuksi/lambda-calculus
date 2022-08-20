require_relative '../../spec_helper'

describe Lambda::NamedExpression::Terms::VariableTerm do
  subject { described_class.new('x') }

  describe '#initialize' do
    context 'with unrecognized symbols' do
      it 'raises an error' do
        (ASCII_CHARACTERS - ('a'..'z').to_a).each do |symbol|
          expect { described_class.new(symbol) }.to raise_error(
            Lambda::NamedExpression::Terms::VariableTermException,
            "FATAL: invalid variable symbol #{symbol}"
          )
        end
      end
    end
  end

  describe '#substitute' do
    context 'with matching substitution variable symbol' do
      let(:substitution) do
        Lambda::NamedExpression::Terms::SubstitutionTerm.new(
          described_class.new('x'),
          described_class.new('y')
        )
      end

      it 'returns the substitution term' do
        expect(subject.substitute(substitution)).to eq(substitution.term)
      end
    end

    context 'with not matching substitution variable symbol' do
      let(:substitution) do
        Lambda::NamedExpression::Terms::SubstitutionTerm.new(
          described_class.new('y'),
          described_class.new('y')
        )
      end

      it 'returns the same term' do
        expect(subject.substitute(substitution)).to eq(subject)
      end
    end
  end

  describe '#to_nameless' do
    context 'with bound variable' do
      let(:lambdas) { 2 }
      let(:bound_variables) { {'x' => 1} }

      it 'returns a nameless variable term bound to the lambda' do
        expect(subject.to_nameless(lambdas, bound_variables)).to eq(
          Lambda::NamelessExpression::Terms::VariableTerm.new(1)
        )
      end
    end

    context 'with free variable' do
      let(:lambdas) { 2 }
      let(:bound_variables) { {'y' => 1} }

      it 'returns a nameless variable term bound to no lambda' do
        expect(subject.to_nameless(lambdas, bound_variables)).to eq(
          Lambda::NamelessExpression::Terms::VariableTerm.new(lambdas)
        )
      end
    end
  end

  describe '#free_variables' do
    context 'with bound variable' do
      let(:bound_variables) { [described_class.new('x')] }

      it 'returns an empty list' do
        expect(subject.free_variables(bound_variables)).to eq([])
      end
    end

    context 'with free variable' do
      let(:bound_variables) { [described_class.new('y')] }

      it 'returns the variable list' do
        expect(subject.free_variables(bound_variables)).to eq([subject])
      end
    end
  end

  describe '#to_s' do
    it 'serializes the term to string' do
      expect(subject.to_s).to eq('x')
    end
  end

  describe '#==' do
    it 'compares the variable terms' do
      expect(subject == described_class.new('x')).to eq(true)
      expect(subject == described_class.new('y')).to eq(false)
    end
  end
end
