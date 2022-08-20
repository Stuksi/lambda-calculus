require_relative '../../spec_helper'

describe Lambda::NamedExpression::Terms::SubstitutionTerm do
  describe '#to_s' do
    let(:variable) { Lambda::NamedExpression::Terms::VariableTerm.new('x') }
    let(:term) { Lambda::NamedExpression::Terms::VariableTerm.new('y') }

    it 'serializes the substitution term to string' do
      expect(described_class.new(variable, term).to_s).to eq('[x->y]')
    end
  end
end
