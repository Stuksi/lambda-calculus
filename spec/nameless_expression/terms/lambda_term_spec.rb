require_relative '../../spec_helper'

describe Lambda::NamelessExpression::Terms::LambdaTerm do
  subject { described_class.new(term) }

  let(:term) do
    Lambda::NamelessExpression::Terms::NonBracketedTerm.new(
      [
        Lambda::NamelessExpression::Terms::VariableTerm.new(0),
        Lambda::NamelessExpression::Terms::VariableTerm.new(1)
      ]
    )
  end

  describe '#substitute' do
    let(:term) do
      Lambda::NamelessExpression::Terms::NonBracketedTerm.new(
        [Lambda::NamelessExpression::Terms::VariableTerm.new(0)],
        Lambda::NamelessExpression::Terms::SubstitutionTerm.new(
          Lambda::NamelessExpression::Terms::VariableTerm.new(0),
          Lambda::NamelessExpression::Terms::VariableTerm.new(1)
        )
      )
    end

    it 'always substitutes the inner term' do
      expect(subject.substitute).to eq(described_class.new(term.substitute))
    end

    context 'with substitution' do
      let(:substitution) do
        Lambda::NamelessExpression::Terms::SubstitutionTerm.new(
          Lambda::NamelessExpression::Terms::VariableTerm.new(0),
          Lambda::NamelessExpression::Terms::NonBracketedTerm.new(
            [Lambda::NamelessExpression::Terms::VariableTerm.new(1)]
          )
        )
      end

      it 'enhances the substitution by offsetting it and then substitutes' do
        expect(subject.substitute(substitution)).to eq(
          described_class.new(
            Lambda::NamelessExpression::Terms::NonBracketedTerm.new(
              [
                Lambda::NamelessExpression::Terms::NonBracketedTerm.new(
                  [Lambda::NamelessExpression::Terms::VariableTerm.new(2)]
                )
              ]
            )
          )
        )
      end
    end
  end

  describe '#offset' do
    it 'raises the critical section when offseting the term' do
      expect(subject.offset(0, 1)).to eq(
        described_class.new(
          Lambda::NamelessExpression::Terms::NonBracketedTerm.new(
            [
              Lambda::NamelessExpression::Terms::VariableTerm.new(0),
              Lambda::NamelessExpression::Terms::VariableTerm.new(2)
            ]
          )
        )
      )
    end
  end

  describe '#to_named' do
    let(:term) do
      Lambda::NamelessExpression::Terms::NonBracketedTerm.new(
        [
          Lambda::NamelessExpression::Terms::VariableTerm.new(0),
          Lambda::NamelessExpression::Terms::VariableTerm.new(2)
        ]
      )
    end

    it 'returns the named lambda term with the next available bound variable symbol' do
      expect(subject.to_named({0 => 'x'}, {0 => 'a'})).to eq(
        Lambda::NamedExpression::Terms::LambdaTerm.new(
          [Lambda::NamedExpression::Terms::VariableTerm.new('b')],
          Lambda::NamedExpression::Terms::NonBracketedTerm.new(
            [
              Lambda::NamedExpression::Terms::VariableTerm.new('b'),
              Lambda::NamedExpression::Terms::VariableTerm.new('x')
            ]
          )
        )
      )
    end
  end

  describe '#to_s' do
    it 'serializes the term to a string' do
      expect(subject.to_s).to eq('^01')
    end
  end

  describe '#==' do
    it 'compares the lambda terms' do
      expect(subject == described_class.new(term)).to eq(true)
      expect(subject == described_class.new(Lambda::NamelessExpression::Terms::VariableTerm.new(2))).to eq(false)
    end
  end
end
