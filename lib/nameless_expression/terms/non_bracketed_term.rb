module Lambda
  module NamelessExpression
    module Terms
      class NonBracketedTerm < NamedExpression::Terms::NonBracketedTerm
        def offset(critical, displacement)
          self.class.new(
            terms.map { |term| term.offset(critical, displacement) },
            substitution
          )
        end

        def to_named(context, lambda_context)
          named_terms = terms.map { |term| term.to_named(context, lambda_context) }
          named_substitution = substitution.to_named(context) if substitution

          if self.class == NonBracketedTerm
            NamedExpression::Terms::NonBracketedTerm.new(named_terms, named_substitution)
          else
            NamedExpression::Terms::BracketedTerm.new(named_terms, named_substitution)
          end
        end

        undef_method :to_nameless, :free_variables
      end
    end
  end
end
