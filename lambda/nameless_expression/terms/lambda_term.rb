module Lambda
  module NamelessExpression
    module Terms
      class LambdaTerm
        attr_reader :term

        def initialize(term)
          @term = term
        end

        def substitute(substitution)
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

        def to_s
          "^#{term}"
        end
      end
    end
  end
end
