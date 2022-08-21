module Lambda
  module NamedExpression
    module Terms
      class VariableTerm
        attr_reader :symbol

        SYMBOLS = ('a'..'z').to_a

        def initialize(symbol)
          raise VariableTermException.new("FATAL: invalid variable symbol #{symbol}") unless self.class::SYMBOLS.include?(symbol)
          @symbol = symbol
        end

        def substitute(substitution = nil)
          if substitution && substitution.variable.symbol == symbol
            substitution.term
          else
            self.class.new(symbol)
          end
        end

        def to_nameless(context, lambdas_depth, bound_variables)
          if bound_variables.key?(symbol)
            NamelessExpression::Terms::VariableTerm.new(bound_variables[symbol])
          else
            NamelessExpression::Terms::VariableTerm.new(context[symbol] + lambdas_depth)
          end
        end

        def free_variables(bound_variables = [])
          if bound_variables.include?(self)
            []
          else
            [VariableTerm.new(symbol)]
          end
        end

        def to_s
          "#{symbol}"
        end

        def ==(variable_term)
          self.class == variable_term.class && symbol == variable_term.symbol
        end

        def hash
          symbol.hash
        end

        alias_method :eql?, :==
      end

      class VariableTermException < Exception; end
    end
  end
end
