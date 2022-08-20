require_relative '../../spec_helper'

describe Lambda::NamedExpression::Terms::LambdaTerm do
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
end
