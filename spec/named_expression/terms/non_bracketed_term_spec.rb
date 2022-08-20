require_relative '../../spec_helper'

describe Lambda::NamedExpression::Terms::NonBracketedTerm do
  let(:terms) do
    [
      Lambda::NamedExpression::Terms::VariableTerm.new('x'),
      Lambda::NamedExpression::Terms::VariableTerm.new('y'),
      Lambda::NamedExpression::Terms::LambdaTerm.new(
        [Lambda::NamedExpression::Terms::VariableTerm.new('z')],
        described_class.new([Lambda::NamedExpression::Terms::VariableTerm.new('x')])
      ),
      Lambda::NamedExpression::Terms::VariableTerm.new('x')
    ]
  end
  let(:substitution) do
    Lambda::NamedExpression::Terms::SubstitutionTerm.new(
      Lambda::NamedExpression::Terms::VariableTerm.new('x'),
      described_class.new([Lambda::NamedExpression::Terms::VariableTerm.new('w')])
    )
  end

  subject { described_class.new(terms, substitution) }

  describe '#substitute' do
    it 'substitutes in every inside term' do
      expect(subject.substitute).to eq(
        described_class.new(
          [
            described_class.new([Lambda::NamedExpression::Terms::VariableTerm.new('w')]),
            Lambda::NamedExpression::Terms::VariableTerm.new('y'),
            Lambda::NamedExpression::Terms::LambdaTerm.new(
              [Lambda::NamedExpression::Terms::VariableTerm.new('z')],
              described_class.new(
                [described_class.new([Lambda::NamedExpression::Terms::VariableTerm.new('w')])]
              )
            ),
            described_class.new(
              [Lambda::NamedExpression::Terms::VariableTerm.new('w')]
            )
          ]
        )
      )
    end

    context 'with substitution inside the substitution' do
      let(:substitution) do
        Lambda::NamedExpression::Terms::SubstitutionTerm.new(
          Lambda::NamedExpression::Terms::VariableTerm.new('x'),
          described_class.new(
            [Lambda::NamedExpression::Terms::VariableTerm.new('v')],
            Lambda::NamedExpression::Terms::SubstitutionTerm.new(
              Lambda::NamedExpression::Terms::VariableTerm.new('v'),
              described_class.new([Lambda::NamedExpression::Terms::VariableTerm.new('w')])
            )
          )
        )
      end

      it 'substitutes inside the substitution first' do
        expect(subject.substitute).to eq(
          described_class.new(
            [
              described_class.new(
                [described_class.new([Lambda::NamedExpression::Terms::VariableTerm.new('w')])]
              ),
              Lambda::NamedExpression::Terms::VariableTerm.new('y'),
              Lambda::NamedExpression::Terms::LambdaTerm.new(
                [Lambda::NamedExpression::Terms::VariableTerm.new('z')],
                described_class.new(
                  [
                    described_class.new(
                      [described_class.new([Lambda::NamedExpression::Terms::VariableTerm.new('w')])]
                    )
                  ]
                )
              ),
              described_class.new(
                [described_class.new([Lambda::NamedExpression::Terms::VariableTerm.new('w')])]
              )
            ]
          )
        )
      end
    end

    context 'with composed substitution' do
      let(:composed_substitution) do
        Lambda::NamedExpression::Terms::SubstitutionTerm.new(
          Lambda::NamedExpression::Terms::VariableTerm.new('w'),
          described_class.new([Lambda::NamedExpression::Terms::VariableTerm.new('y')])
        )
      end

      it 'first substitutes the initial term and then substitute with the composed substitution' do
        expect(subject.substitute(composed_substitution)).to eq(
          described_class.new(
            [
              described_class.new(
                [described_class.new([Lambda::NamedExpression::Terms::VariableTerm.new('y')])]
              ),
              Lambda::NamedExpression::Terms::VariableTerm.new('y'),
              Lambda::NamedExpression::Terms::LambdaTerm.new(
                [Lambda::NamedExpression::Terms::VariableTerm.new('z')],
                described_class.new(
                  [
                    described_class.new(
                      [described_class.new([Lambda::NamedExpression::Terms::VariableTerm.new('y')])]
                    )
                  ]
                )
              ),
              described_class.new(
                [described_class.new([Lambda::NamedExpression::Terms::VariableTerm.new('y')])]
              )
            ]
          )
        )
      end
    end
  end

  describe '#to_nameless' do
    context 'without a substitution' do
      let(:substitution) { nil }

      it 'converts the term to nameless term' do
        expect(subject.to_nameless(0, {})).to eq(
          Lambda::NamelessExpression::Terms::NonBracketedTerm.new(
            [
              Lambda::NamelessExpression::Terms::VariableTerm.new(0),
              Lambda::NamelessExpression::Terms::VariableTerm.new(0),
              Lambda::NamelessExpression::Terms::LambdaTerm.new(
                Lambda::NamelessExpression::Terms::NonBracketedTerm.new(
                  [Lambda::NamelessExpression::Terms::VariableTerm.new(1)]
                )
              ),
              Lambda::NamelessExpression::Terms::VariableTerm.new(0)
            ]
          )
        )
      end
    end

    context 'with a substitution' do
      let(:substitution) do
        Lambda::NamedExpression::Terms::SubstitutionTerm.new(
          Lambda::NamedExpression::Terms::VariableTerm.new('x'),
          described_class.new([Lambda::NamedExpression::Terms::VariableTerm.new('w')])
        )
      end

      it 'first substitutes and then converts the term to nameless term' do
        expect(subject.to_nameless(0, {})).to eq(
          Lambda::NamelessExpression::Terms::NonBracketedTerm.new(
            [
              Lambda::NamelessExpression::Terms::NonBracketedTerm.new(
                [Lambda::NamelessExpression::Terms::VariableTerm.new(0)]
              ),
              Lambda::NamelessExpression::Terms::VariableTerm.new(0),
              Lambda::NamelessExpression::Terms::LambdaTerm.new(
                Lambda::NamelessExpression::Terms::NonBracketedTerm.new(
                  [
                    Lambda::NamelessExpression::Terms::NonBracketedTerm.new(
                      [Lambda::NamelessExpression::Terms::VariableTerm.new(1)]
                    )
                  ]
                )
              ),
              Lambda::NamelessExpression::Terms::NonBracketedTerm.new(
                [Lambda::NamelessExpression::Terms::VariableTerm.new(0)]
              )
            ]
          )
        )
      end
    end
  end

  describe '#free_variables' do
    context 'without bound variables' do
      it 'returns the free variables of all of the terms' do
        expect(subject.free_variables).to eq(
          [
            Lambda::NamedExpression::Terms::VariableTerm.new('x'),
            Lambda::NamedExpression::Terms::VariableTerm.new('y')
          ]
        )
      end
    end

    context 'with bound variables' do
      let(:bound_variables) do
        [Lambda::NamedExpression::Terms::VariableTerm.new('x')]
      end

      it 'returns the free variables of all of the terms' do
        expect(subject.free_variables(bound_variables)).to eq(
          [Lambda::NamedExpression::Terms::VariableTerm.new('y')]
        )
      end
    end
  end

  describe '#to_s' do
    it 'serializes the term to a string' do
      expect(subject.to_s).to eq('xy^z.xx[x->w]')
    end
  end

  describe '#==' do
    it 'compares the variable terms' do
      expect(subject == described_class.new(terms, substitution)).to eq(true)
      expect(subject == described_class.new([Lambda::NamedExpression::Terms::VariableTerm.new('y')], substitution)).to eq(false)
      expect(subject == described_class.new(terms, nil)).to eq(false)
    end
  end
end
