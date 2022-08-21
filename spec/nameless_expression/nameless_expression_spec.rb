require_relative '../spec_helper'

describe Lambda::NamelessExpression::NamelessExpression do
  subject { described_class.new(term) }

  let(:term) do
    Lambda::NamelessExpression::Terms::BracketedTerm.new(
      [
        Lambda::NamelessExpression::Terms::VariableTerm.new(0),
        Lambda::NamelessExpression::Terms::VariableTerm.new(0),
        Lambda::NamelessExpression::Terms::BracketedTerm.new(
          [
            Lambda::NamelessExpression::Terms::BracketedTerm.new(
              [
                Lambda::NamelessExpression::Terms::LambdaTerm.new(
                  Lambda::NamelessExpression::Terms::NonBracketedTerm.new(
                    [Lambda::NamelessExpression::Terms::VariableTerm.new(1)]
                  )
                )
              ],
              Lambda::NamelessExpression::Terms::SubstitutionTerm.new(
                Lambda::NamelessExpression::Terms::VariableTerm.new(0),
                Lambda::NamelessExpression::Terms::NonBracketedTerm.new(
                  [Lambda::NamelessExpression::Terms::VariableTerm.new(1)],
                  Lambda::NamelessExpression::Terms::SubstitutionTerm.new(
                    Lambda::NamelessExpression::Terms::VariableTerm.new(1),
                    Lambda::NamelessExpression::Terms::NonBracketedTerm.new(
                      [Lambda::NamelessExpression::Terms::VariableTerm.new(2)]
                    )
                  )
                )
              )
            ),
            Lambda::NamelessExpression::Terms::VariableTerm.new(0)
          ]
        ),
      ],
      Lambda::NamelessExpression::Terms::SubstitutionTerm.new(
        Lambda::NamelessExpression::Terms::VariableTerm.new(0),
        Lambda::NamelessExpression::Terms::BracketedTerm.new(
          [
            Lambda::NamelessExpression::Terms::LambdaTerm.new(
              Lambda::NamelessExpression::Terms::NonBracketedTerm.new(
                [
                  Lambda::NamelessExpression::Terms::LambdaTerm.new(
                    Lambda::NamelessExpression::Terms::NonBracketedTerm.new(
                      [
                        Lambda::NamelessExpression::Terms::VariableTerm.new(2),
                        Lambda::NamelessExpression::Terms::VariableTerm.new(1),
                        Lambda::NamelessExpression::Terms::VariableTerm.new(0)
                      ]
                    )
                  )
                ]
              )
            )
          ]
        )
      )
    )
  end

  describe '#to_named' do
    it 'substitutes and converts the term to named term' do
      expect(subject.to_named.to_s).to eq('((^a.^b.zab)(^a.^b.zab)((^a.x)(^a.^b.zab)))')
    end
  end
end
