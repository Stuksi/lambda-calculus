require_relative '../../spec_helper'

describe Lambda::NamelessExpression::Terms::NonBracketedTerm do
  subject { described_class.new(terms) }

  let(:terms) do
    [
      Lambda::NamelessExpression::Terms::VariableTerm.new(0),
      Lambda::NamelessExpression::Terms::VariableTerm.new(1),
      Lambda::NamelessExpression::Terms::LambdaTerm.new(
        Lambda::NamelessExpression::Terms::VariableTerm.new(0)
      )
    ]
  end

  describe '#offset' do
    it 'offsets the inner terms' do
      expect(subject.offset(0, 1)).to eq(
        described_class.new(
          [
            Lambda::NamelessExpression::Terms::VariableTerm.new(1),
            Lambda::NamelessExpression::Terms::VariableTerm.new(2),
            Lambda::NamelessExpression::Terms::LambdaTerm.new(
              Lambda::NamelessExpression::Terms::VariableTerm.new(0)
            )
          ]
        )
      )
    end
  end
end
