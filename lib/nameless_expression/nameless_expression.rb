module Lambda
  module NamelessExpression
    class NamelessExpression < NamedExpression::NamedExpression
      def to_named
        context = Terms::VariableTerm::SYMBOLS.zip(
          NamedExpression::Terms::VariableTerm::SYMBOLS.reverse
        ).to_h

        NamedExpression::NamedExpression.new(term.to_named(context, {}))
      end

      undef_method :to_nameless, :alpha_eql?
    end
  end
end
