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
        NamelessExpression::NamelessExpression.new(term.to_nameless(0, {}))
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
