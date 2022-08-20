require_relative '../../spec_helper'

describe Lambda::NamedExpression::Terms::LambdaTerm do
  let(:bound_variables) do
    [
      Lambda::NamedExpression::Terms::VariableTerm.new('y'),
      Lambda::NamedExpression::Terms::VariableTerm.new('z')
    ]
  end
  let(:term) do
    Lambda::NamedExpression::Terms::NonBracketedTerm.new(
      [
        Lambda::NamedExpression::Terms::VariableTerm.new('x'),
        Lambda::NamedExpression::Terms::VariableTerm.new('z'),
        Lambda::NamedExpression::Terms::VariableTerm.new('y'),
        Lambda::NamedExpression::Terms::VariableTerm.new('w'),
      ]
    )
  end

  subject { described_class.new(bound_variables, term) }

  describe '#substitute' do
    let(:bound_variables) do
      [Lambda::NamedExpression::Terms::VariableTerm.new('x')]
    end
    let(:term) do
      Lambda::NamedExpression::Terms::NonBracketedTerm.new(
        [Lambda::NamedExpression::Terms::VariableTerm.new('y')],
        Lambda::NamedExpression::Terms::SubstitutionTerm.new(
          Lambda::NamedExpression::Terms::VariableTerm.new('y'),
          Lambda::NamedExpression::Terms::VariableTerm.new('z')
        )
      )
    end

    it 'always substitutes the inner term' do
      expect(subject.substitute).to eq(described_class.new(bound_variables, term.substitute))
    end

    context 'with bound variables including the substitution variable' do
      let(:substitution) do
        Lambda::NamedExpression::Terms::SubstitutionTerm.new(
          Lambda::NamedExpression::Terms::VariableTerm.new('x'),
          Lambda::NamedExpression::Terms::NonBracketedTerm.new(
            [Lambda::NamedExpression::Terms::VariableTerm.new('w')]
          )
        )
      end

      it 'substitutes only the inner term' do
        expect(subject.substitute(substitution)).to eq(described_class.new(bound_variables, term.substitute))
      end
    end

    context 'with bound variables not including the substitution variable' do
      context 'with free variables including the substitution variable' do
        context 'with substitution free variables not intersecting the bound variables' do
          let(:substitution) do
            Lambda::NamedExpression::Terms::SubstitutionTerm.new(
              Lambda::NamedExpression::Terms::VariableTerm.new('z'),
              Lambda::NamedExpression::Terms::NonBracketedTerm.new(
                [Lambda::NamedExpression::Terms::VariableTerm.new('w')]
              )
            )
          end

          it 'substitutes the term' do
            expect(subject.substitute(substitution)).to eq(described_class.new(
              bound_variables,
              Lambda::NamedExpression::Terms::NonBracketedTerm.new(
                [Lambda::NamedExpression::Terms::NonBracketedTerm.new(
                  [Lambda::NamedExpression::Terms::VariableTerm.new('w')]
                )]
              )
            ))
          end
        end
      end

      context 'with free variables not including the substitution variable' do
        let(:substitution) do
          Lambda::NamedExpression::Terms::SubstitutionTerm.new(
            Lambda::NamedExpression::Terms::VariableTerm.new('x'),
            Lambda::NamedExpression::Terms::NonBracketedTerm.new(
              [Lambda::NamedExpression::Terms::VariableTerm.new('w')]
            )
          )
        end

        it 'substitutes only the inner term' do
          expect(subject.substitute(substitution)).to eq(described_class.new(bound_variables, term.substitute))
        end
      end
    end

    context 'with renaming demanded' do
      let(:term) do
        Lambda::NamedExpression::Terms::NonBracketedTerm.new(
          [
            Lambda::NamedExpression::Terms::VariableTerm.new('x'),
            Lambda::NamedExpression::Terms::VariableTerm.new('z')
          ]
        )
      end
      let(:substitution) do
        Lambda::NamedExpression::Terms::SubstitutionTerm.new(
          Lambda::NamedExpression::Terms::VariableTerm.new('z'),
          Lambda::NamedExpression::Terms::NonBracketedTerm.new(
            [Lambda::NamedExpression::Terms::VariableTerm.new('x')]
          )
        )
      end

      it 'renames the problem variables and substitutes' do
        expect(subject.substitute(substitution)).to eq(described_class.new(
          [Lambda::NamedExpression::Terms::VariableTerm.new('a')],
          Lambda::NamedExpression::Terms::NonBracketedTerm.new(
            [
              Lambda::NamedExpression::Terms::VariableTerm.new('a'),
              Lambda::NamedExpression::Terms::NonBracketedTerm.new(
                [Lambda::NamedExpression::Terms::VariableTerm.new('x')]
              )
            ]
          )
        ))
      end
    end
  end

  describe '#to_nameless' do
    let(:bound_variables) do
      [
        Lambda::NamedExpression::Terms::VariableTerm.new('x'),
        Lambda::NamedExpression::Terms::VariableTerm.new('y'),
        Lambda::NamedExpression::Terms::VariableTerm.new('z')
      ]
    end

    context 'with term without bound variables' do
      let(:term) do
        Lambda::NamedExpression::Terms::NonBracketedTerm.new(
          [
            Lambda::NamedExpression::Terms::VariableTerm.new('w')
          ]
        )
      end

      it 'converts them to a nameless term with variable index outside the lambdas' do
        expect(subject.to_nameless(0, {})).to eq(
          Lambda::NamelessExpression::Terms::LambdaTerm.new(
            Lambda::NamelessExpression::Terms::NonBracketedTerm.new(
              [
                Lambda::NamelessExpression::Terms::LambdaTerm.new(
                  Lambda::NamelessExpression::Terms::NonBracketedTerm.new(
                    [
                      Lambda::NamelessExpression::Terms::LambdaTerm.new(
                        Lambda::NamelessExpression::Terms::NonBracketedTerm.new(
                          [Lambda::NamelessExpression::Terms::VariableTerm.new(3)]
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
    end

    context 'with term with bound variables' do
      let(:term) do
        Lambda::NamedExpression::Terms::NonBracketedTerm.new(
          [
            Lambda::NamedExpression::Terms::VariableTerm.new('x'),
            Lambda::NamedExpression::Terms::VariableTerm.new('z'),
            Lambda::NamedExpression::Terms::VariableTerm.new('y')
          ]
        )
      end

      it 'converts them to a nameless term with variable index outside the lambdas' do
        expect(subject.to_nameless(0, {})).to eq(
          Lambda::NamelessExpression::Terms::LambdaTerm.new(
            Lambda::NamelessExpression::Terms::NonBracketedTerm.new(
              [
                Lambda::NamelessExpression::Terms::LambdaTerm.new(
                  Lambda::NamelessExpression::Terms::NonBracketedTerm.new(
                    [
                      Lambda::NamelessExpression::Terms::LambdaTerm.new(
                        Lambda::NamelessExpression::Terms::NonBracketedTerm.new(
                          [
                            Lambda::NamelessExpression::Terms::VariableTerm.new(2),
                            Lambda::NamelessExpression::Terms::VariableTerm.new(0),
                            Lambda::NamelessExpression::Terms::VariableTerm.new(1)
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
    end
  end

  describe '#free_variables' do
    let(:accumulated_bound_variables) do
      [Lambda::NamedExpression::Terms::VariableTerm.new('x')]
    end

    context 'with accumulated bounded variables' do
      it 'returns the free variable list' do
        expect(subject.free_variables(accumulated_bound_variables)).to eq(
          [
            Lambda::NamedExpression::Terms::VariableTerm.new('w')
          ]
        )
      end
    end

    context 'without accumulated bounded variables' do
      it 'returns the free variable list' do
        expect(subject.free_variables).to eq(
          [
            Lambda::NamedExpression::Terms::VariableTerm.new('x'),
            Lambda::NamedExpression::Terms::VariableTerm.new('w')
          ]
        )
      end
    end
  end

  describe '#to_s' do
    it 'serializes the term to a string' do
      expect(subject.to_s).to eq('^yz.xzyw')
    end
  end

  describe '#==' do
    it 'compares the lambda terms' do
      expect(subject == described_class.new(bound_variables, term)).to eq(true)
      expect(subject == described_class.new([Lambda::NamedExpression::Terms::VariableTerm.new('x')], term)).to eq(false)
    end
  end
end
