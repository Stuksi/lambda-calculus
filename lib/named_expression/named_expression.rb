module Lambda
  module NamedExpression
    class NamedExpression
      attr_reader :term

      def initialize(term)
        @term = term
      end

      def substitute
        term.substitute
      end

      def to_nameless
        substituted_term = term.substitute
        context = substituted_term.free_variables.map(&:symbol).zip(
          NamelessExpression::Terms::VariableTerm::SYMBOLS
        ).to_h

        NamelessExpression::NamelessExpression.new(substituted_term.to_nameless(context, 0, {}))
      end

      def alpha_equivalent_to(named_expression)
        self.to_nameless.to_s == named_expression.to_nameless.to_s
      end

      def to_s
        term.to_s
      end

      def ==(named_expression)
        self.class == named_expression.class && self.term == named_expression.term
      end
    end
  end
end
