require_relative '../spec_helper'

describe Lambda::NamedExpression::NamedExpression do
  subject { described_class.new(term) }

  let(:term) do
    Lambda::NamedExpression::Terms::BracketedTerm.new(
      [
        Lambda::NamedExpression::Terms::VariableTerm.new('x'),
        Lambda::NamedExpression::Terms::VariableTerm.new('y'),
        Lambda::NamedExpression::Terms::BracketedTerm.new(
          [
            Lambda::NamedExpression::Terms::BracketedTerm.new(
              [
                Lambda::NamedExpression::Terms::LambdaTerm.new(
                  [Lambda::NamedExpression::Terms::VariableTerm.new('x')],
                  Lambda::NamedExpression::Terms::NonBracketedTerm.new(
                    [Lambda::NamedExpression::Terms::VariableTerm.new('z')]
                  )
                )
              ],
              Lambda::NamedExpression::Terms::SubstitutionTerm.new(
                Lambda::NamedExpression::Terms::VariableTerm.new('z'),
                Lambda::NamedExpression::Terms::NonBracketedTerm.new(
                  [Lambda::NamedExpression::Terms::VariableTerm.new('y')],
                  Lambda::NamedExpression::Terms::SubstitutionTerm.new(
                    Lambda::NamedExpression::Terms::VariableTerm.new('y'),
                    Lambda::NamedExpression::Terms::NonBracketedTerm.new(
                      [Lambda::NamedExpression::Terms::VariableTerm.new('x')]
                    )
                  )
                )
              )
            ),
            Lambda::NamedExpression::Terms::VariableTerm.new('y')
          ]
        ),
      ],
      Lambda::NamedExpression::Terms::SubstitutionTerm.new(
        Lambda::NamedExpression::Terms::VariableTerm.new('y'),
        Lambda::NamedExpression::Terms::BracketedTerm.new(
          [
            Lambda::NamedExpression::Terms::LambdaTerm.new(
              [
                Lambda::NamedExpression::Terms::VariableTerm.new('w'),
                Lambda::NamedExpression::Terms::VariableTerm.new('u')
              ],
              Lambda::NamedExpression::Terms::NonBracketedTerm.new(
                [
                  Lambda::NamedExpression::Terms::VariableTerm.new('v'),
                  Lambda::NamedExpression::Terms::VariableTerm.new('w'),
                  Lambda::NamedExpression::Terms::VariableTerm.new('u')
                ]
              )
            )
          ]
        )
      )
    )
  end

  describe '#substitute' do
    it 'applies the substitutions to the term' do
      expect(subject.substitute.to_s).to eq('(x(^wu.vwu)((^a.x)(^wu.vwu)))')
    end
  end

  describe '#to_nameless' do
    it 'substitutes and then converts the term to nameless' do
      expect(subject.to_nameless.to_s).to eq('(0(^^310)((^1)(^^310)))')
    end
  end

  describe '#to_s' do
    it 'serializes the term to a string' do
      expect(subject.to_s).to eq('(xy((^x.z)[z->y[y->x]]y))[y->(^wu.vwu)]')
    end
  end

  describe '#==' do
    it 'compares the variable terms' do
      expect(subject == described_class.new(term)).to eq(true)
      expect(subject == described_class.new(Lambda::NamedExpression::Terms::VariableTerm.new('y'))).to eq(false)
    end
  end
end
