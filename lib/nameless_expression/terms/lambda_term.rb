module Lambda
  module NamelessExpression
    module Terms
      class LambdaTerm
        attr_reader :term

        def initialize(term)
          @term = term
        end

        def substitute(substitution = nil)
          substituted_term = term.substitute

          if substitution
            enhanced_substitution = SubstitutionTerm.new(
              VariableTerm.new(substitution.variable.symbol + 1),
              substitution.term.offset(0, 1)
            )
            substituted_term = substituted_term.substitute(enhanced_substitution)
          end

          LambdaTerm.new(substituted_term)
        end

        def offset(critical, displacement)
          LambdaTerm.new(term.offset(critical + 1, displacement))
        end

        def to_named(context, lambda_context)
          bound_variable = NamedExpression::Terms::VariableTerm::SYMBOLS[lambda_context.length]

          NamedExpression::Terms::LambdaTerm.new(
            [NamedExpression::Terms::VariableTerm.new(bound_variable)],
            term.to_named(
              context,
              lambda_context.merge({
                lambda_context.length => bound_variable
              })
            )
          )
        end

        def to_s
          "^#{term}"
        end

        def ==(lambda_term)
          self.class == lambda_term.class && term == lambda_term.term
        end
      end
    end
  end
end
