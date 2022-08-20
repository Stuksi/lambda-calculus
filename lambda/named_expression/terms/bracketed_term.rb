require_relative 'non_bracketed_term'

module Lambda
  module NamedExpression
    module Terms
      class BracketedTerm < NonBracketedTerm
        def to_nameless(lambdas, bound_variables)
          nameless_substitution = substitution.to_nameless if substitution

          NamelessExpression::Terms::BracketedTerm.new(
            terms.map { |term| term.to_nameless(lambdas, bound_variables) },
            nameless_substitution
          )
        end

        def to_s
          "(#{terms.map(&:to_s).join})#{substitution}"
        end
      end
    end
  end
end
