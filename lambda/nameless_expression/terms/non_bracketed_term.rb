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
      end
    end
  end
end
