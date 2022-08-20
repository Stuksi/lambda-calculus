require_relative '../../spec_helper'

describe Lambda::NamedExpression::Terms::BracketedTerm do
  let(:terms) do
    [
      Lambda::NamedExpression::Terms::VariableTerm.new('x'),
      Lambda::NamedExpression::Terms::VariableTerm.new('y'),
      Lambda::NamedExpression::Terms::LambdaTerm.new(
        [Lambda::NamedExpression::Terms::VariableTerm.new('z')],
        Lambda::NamedExpression::Terms::NonBracketedTerm.new(
          [Lambda::NamedExpression::Terms::VariableTerm.new('x')]
        )
      ),
      Lambda::NamedExpression::Terms::VariableTerm.new('x')
    ]
  end
  let(:substitution) do
    Lambda::NamedExpression::Terms::SubstitutionTerm.new(
      Lambda::NamedExpression::Terms::VariableTerm.new('x'),
      Lambda::NamedExpression::Terms::NonBracketedTerm.new(
        [Lambda::NamedExpression::Terms::VariableTerm.new('w')]
      )
    )
  end

  subject { described_class.new(terms, substitution) }

  describe '#to_s' do
    it 'serializes the term to a string' do
      expect(subject.to_s).to eq('(xy^z.xx)[x->w]')
    end
  end
end
