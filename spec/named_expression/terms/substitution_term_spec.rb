require_relative '../../spec_helper'

describe Lambda::NamedExpression::Terms::SubstitutionTerm do
  let(:variable) { Lambda::NamedExpression::Terms::VariableTerm.new('x') }
  let(:term) { Lambda::NamedExpression::Terms::VariableTerm.new('y') }

  describe '#to_nameless' do
    it 'converts the substitution term to nameless' do
      expect(described_class.new(variable, term).to_nameless({'x'=>0,'y'=>1}).to_s).to eq('[0->1]')
    end
  end

  describe '#to_s' do
    it 'serializes the substitution term to string' do
      expect(described_class.new(variable, term).to_s).to eq('[x->y]')
    end
  end
end
