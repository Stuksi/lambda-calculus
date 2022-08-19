module Lambda
  module NamedExpression
    module Terms
      class VariableTerm
        attr_reader :symbol

        SYMBOLS = ('a'..'z').to_a

        def initialize(symbol)
          @symbol = symbol
        end

        def substitute(substitution)
          if substitution&.variable&.symbol === symbol
            substitution.term
          else
            self.class.new(symbol)
          end
        end

        def free_variables
          [symbol]
        end

        def to_s
          "#{symbol}"
        end
      end
    end
  end
end
