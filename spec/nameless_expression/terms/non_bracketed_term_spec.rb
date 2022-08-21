require_relative '../../spec_helper'

describe Lambda::NamelessExpression::Terms::NonBracketedTerm do
  subject { described_class.new(terms, substitution) }

  let(:terms) do
    [
      Lambda::NamelessExpression::Terms::VariableTerm.new(0),
      Lambda::NamelessExpression::Terms::VariableTerm.new(1),
      Lambda::NamelessExpression::Terms::LambdaTerm.new(
        Lambda::NamelessExpression::Terms::VariableTerm.new(0)
      )
    ]
  end
  let(:substitution) { nil }

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

  describe '#to_named' do
    context 'without a substitution' do
      it 'converts the term to named term' do
        expect(subject.to_named({0=>'x', 1=>'y'}, {})).to eq(
          Lambda::NamedExpression::Terms::NonBracketedTerm.new(
            [
              Lambda::NamedExpression::Terms::VariableTerm.new('x'),
              Lambda::NamedExpression::Terms::VariableTerm.new('y'),
              Lambda::NamedExpression::Terms::LambdaTerm.new(
                [Lambda::NamedExpression::Terms::VariableTerm.new('a')],
                Lambda::NamedExpression::Terms::VariableTerm.new('a')
              )
            ]
          )
        )
      end
    end

    context 'with a substitution' do
      let(:substitution) do
        Lambda::NamelessExpression::Terms::SubstitutionTerm.new(
          Lambda::NamelessExpression::Terms::VariableTerm.new(0),
          described_class.new([Lambda::NamelessExpression::Terms::VariableTerm.new(1)])
        )
      end

      it 'first substitutes and then converts the term to named term' do
        expect(subject.to_named({0=>'x', 1=>'y'}, {})).to eq(
          Lambda::NamedExpression::Terms::NonBracketedTerm.new(
            [
              Lambda::NamedExpression::Terms::NonBracketedTerm.new(
                [Lambda::NamedExpression::Terms::VariableTerm.new('y')]
              ),
              Lambda::NamedExpression::Terms::VariableTerm.new('y'),
              Lambda::NamedExpression::Terms::LambdaTerm.new(
                [Lambda::NamedExpression::Terms::VariableTerm.new('a')],
                Lambda::NamedExpression::Terms::VariableTerm.new('a')
              )
            ]
          )
        )
      end
    end
  end
end
