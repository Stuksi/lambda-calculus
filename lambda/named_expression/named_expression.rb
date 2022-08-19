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

      def to_s
        term.to_s
      end
    end
  end
end
