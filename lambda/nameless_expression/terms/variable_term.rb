module Lambda
  module NamelessExpression
    module Terms
      class VariableTerm < NamedExpression::Terms::VariableTerm
        SYMBOLS = (0..9).to_a

        def offset(critical, displacement)
          if symbol < critical
            VariableTerm.new(symbol)
          else
            raise VariableTermException.new('FATAL: offset overflow') if symbol + displacement > 9
            VariableTerm.new(symbol + displacement)
          end
        end

        def to_named(context, lambda_context)
          if lambda_context.key?(symbol)
            NamedExpression::Terms::VariableTerm.new(lambda_context[lambda_context.length - 1 - symbol])
          else
            NamedExpression::Terms::VariableTerm.new(context[symbol - lambda_context.length])
          end
        end

        undef_method :to_nameless, :free_variables
      end

      class VariableTermException < Exception; end
    end
  end
end
