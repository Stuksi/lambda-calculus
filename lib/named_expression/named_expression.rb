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
        context = term.free_variables.map(&:symbol).zip(
          NamelessExpression::Terms::VariableTerm::SYMBOLS
        ).to_h

        NamelessExpression::NamelessExpression.new(term.to_nameless(context, {}))
      end

      def alpha_eql?(named_expression)
        self.to_nameless.to_s == named_expression.to_nameless.to_s
      end

      def subterm?(named_expression)
        self.to_s.include?(named_expression.to_s)
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
