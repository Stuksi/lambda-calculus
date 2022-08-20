module Lambda
  module NamedExpression
    module Terms
      class NonBracketedTerm
        attr_reader :terms, :substitution

        def initialize(terms, substitution = nil)
          @terms = terms
          @substitution = substitution
        end

        def substitute(composed_substitution = nil)
          if substitution
            substituted_substitution = SubstitutionTerm.new(substitution.variable, substitution.term.substitute)
          end

          substituted_terms = terms.map { |term| term.substitute(substituted_substitution) }
          if composed_substitution
            substituted_terms.map! { |term| term.substitute(composed_substitution) }
          end

          self.class.new(substituted_terms)
        end

        def to_nameless(lambdas_depth, bound_variables)
          nameless_terms = self.substitute.terms.map { |term| term.to_nameless(lambdas_depth, bound_variables) }

          if self.class == NonBracketedTerm
            NamelessExpression::Terms::NonBracketedTerm.new(nameless_terms)
          else
            NamelessExpression::Terms::BracketedTerm.new(nameless_terms)
          end
        end

        def free_variables(bound_variables = [])
          terms.map { |term| term.free_variables(bound_variables) }
               .flatten
               .uniq { |variable| variable.symbol }
        end

        def to_s
          "#{terms.map(&:to_s).join}#{substitution}"
        end

        def ==(non_bracketed_term)
          self.class == non_bracketed_term.class &&
          self.terms == non_bracketed_term.terms &&
          self.substitution == non_bracketed_term.substitution
        end
      end
    end
  end
end
