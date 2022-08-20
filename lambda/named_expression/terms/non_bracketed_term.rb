require_relative 'substitution_term'

module Lambda
  module NamedExpression
    module Terms
      class NonBracketedTerm
        attr_reader :terms, :substitution

        def initialize(terms, substitution = nil)
          @terms = terms
          @substitution = substitution
        end

        def substitute(extended_substitution = nil)
          if substitution
            substituted_substitution = SubstitutionTerm.new(substitution.variable, substitution.term.substitute)
          end

          substituted_terms = terms.map { |term| term.substitute(substituted_substitution) }
          if extended_substitution
            substituted_terms.map! { |term| term.substitute(extended_substitution) }
          end

          self.class.new(substituted_terms)
        end

        def to_nameless(lambdas, bound_variables)
          nameless_substitution = substitution.to_nameless if substitution

          NamelessExpression::Terms::NonBracketedTerm.new(
            terms.map { |term| term.to_nameless(lambdas, bound_variables) },
            nameless_substitution
          )
        end

        def free_variables
          terms.map(&:free_variables).flatten
        end

        def to_s
          "#{terms.map(&:to_s).join}#{substitution}"
        end
      end
    end
  end
end
