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

        def to_nameless(lambdas, bound_variables)
          if bound_variables.key?(symbol)
            NamelessExpression::Terms::VariableTerm.new(bound_variables[symbol])
          else
            NamelessExpression::Terms::VariableTerm.new(lambdas)
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
