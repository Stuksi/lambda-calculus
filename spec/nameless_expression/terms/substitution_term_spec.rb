require_relative '../../spec_helper'

describe Lambda::NamelessExpression::Terms::SubstitutionTerm do
  let(:variable) { Lambda::NamelessExpression::Terms::VariableTerm.new(0) }
  let(:term) { Lambda::NamelessExpression::Terms::VariableTerm.new(1) }

  describe '#to_named' do
    it 'converts the substitution term to named' do
      expect(described_class.new(variable, term).to_named({0=>'z',1=>'y'}).to_s).to eq('[z->y]')
    end
  end
end
