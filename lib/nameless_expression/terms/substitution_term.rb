module Lambda
  module NamelessExpression
    module Terms
      class SubstitutionTerm < NamedExpression::Terms::SubstitutionTerm
        def to_named(context)
          NamedExpression::Terms::SubstitutionTerm.new(
            variable.to_named(context, {}),
            term.to_named(context, {})
          )
        end

        undef_method :to_nameless
      end
    end
  end
end
