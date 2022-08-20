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
          nameless_terms = self.substitute.terms.map { |term| term.to_nameless(lambdas, bound_variables) }

          self.class.new(nameless_terms)
        end

        def free_variables(bound_variables = [])
          terms.map { |term| term.free_variables(bound_variables) }.flatten
        end

        def to_s
          "#{terms.map(&:to_s).join}#{substitution}"
        end

        def ==(non_bracketed_term)
          self.class == non_bracketed_term.class &&
          self.terms == non_bracketed_term.terms
        end
      end
    end
  end
end
