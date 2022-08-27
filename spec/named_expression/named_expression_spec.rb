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
    it 'converts the term to nameless' do
      expect(subject.to_nameless.to_s).to eq('(01((^3)[2->1[1->0]]1))[1->(^^510)]')
    end
  end

  describe '#alpha_eql?' do
    let(:alpha_equivalent_term) do
      Lambda::NamedExpression::Terms::BracketedTerm.new(
        [
          Lambda::NamedExpression::Terms::VariableTerm.new('a'),
          Lambda::NamedExpression::Terms::VariableTerm.new('b'),
          Lambda::NamedExpression::Terms::BracketedTerm.new(
            [
              Lambda::NamedExpression::Terms::BracketedTerm.new(
                [
                  Lambda::NamedExpression::Terms::LambdaTerm.new(
                    [Lambda::NamedExpression::Terms::VariableTerm.new('a')],
                    Lambda::NamedExpression::Terms::NonBracketedTerm.new(
                      [Lambda::NamedExpression::Terms::VariableTerm.new('c')]
                    )
                  )
                ],
                Lambda::NamedExpression::Terms::SubstitutionTerm.new(
                  Lambda::NamedExpression::Terms::VariableTerm.new('c'),
                  Lambda::NamedExpression::Terms::NonBracketedTerm.new(
                    [Lambda::NamedExpression::Terms::VariableTerm.new('b')],
                    Lambda::NamedExpression::Terms::SubstitutionTerm.new(
                      Lambda::NamedExpression::Terms::VariableTerm.new('b'),
                      Lambda::NamedExpression::Terms::NonBracketedTerm.new(
                        [Lambda::NamedExpression::Terms::VariableTerm.new('a')]
                      )
                    )
                  )
                )
              ),
              Lambda::NamedExpression::Terms::VariableTerm.new('b')
            ]
          ),
        ],
        Lambda::NamedExpression::Terms::SubstitutionTerm.new(
          Lambda::NamedExpression::Terms::VariableTerm.new('b'),
          Lambda::NamedExpression::Terms::BracketedTerm.new(
            [
              Lambda::NamedExpression::Terms::LambdaTerm.new(
                [
                  Lambda::NamedExpression::Terms::VariableTerm.new('d'),
                  Lambda::NamedExpression::Terms::VariableTerm.new('e')
                ],
                Lambda::NamedExpression::Terms::NonBracketedTerm.new(
                  [
                    Lambda::NamedExpression::Terms::VariableTerm.new('f'),
                    Lambda::NamedExpression::Terms::VariableTerm.new('d'),
                    Lambda::NamedExpression::Terms::VariableTerm.new('e')
                  ]
                )
              )
            ]
          )
        )
      )
    end
    let(:not_alpha_equivalent_term) do
      Lambda::NamedExpression::Terms::BracketedTerm.new(
        [
          Lambda::NamedExpression::Terms::VariableTerm.new('a'),
          Lambda::NamedExpression::Terms::VariableTerm.new('b')
        ]
      )
    end

    it 'compares named expression by alpha equivalence' do
      expect(subject.alpha_eql?(subject)).to eq(true)
      expect(subject.alpha_eql?(described_class.new(alpha_equivalent_term))).to eq(true)
      expect(subject.alpha_eql?(described_class.new(not_alpha_equivalent_term))).to eq(false)
    end
  end

  describe '#subterm?' do
    let(:subterm) do
      Lambda::NamedExpression::Terms::NonBracketedTerm.new(
        [
          Lambda::NamedExpression::Terms::VariableTerm.new('x'),
          Lambda::NamedExpression::Terms::VariableTerm.new('y')
        ]
      )
    end
    let(:not_subterm) do
      Lambda::NamedExpression::Terms::VariableTerm.new('a')
    end

    it 'check if the passed as a parameter term is a subterm' do
      expect(subject.subterm?(subterm)).to eq(true)
      expect(subject.subterm?(not_subterm)).to eq(false)
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
