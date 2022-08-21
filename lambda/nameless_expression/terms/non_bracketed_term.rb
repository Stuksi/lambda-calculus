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

        undef_method :to_nameless, :free_variables
      end
    end
  end
end
