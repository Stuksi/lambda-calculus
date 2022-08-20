module Lambda
  module NamelessExpression
    module Terms
      class VariableTerm < NamedExpression::Terms::VariableTerm
        SYMBOLS = ('0'..'9').to_a

        def offset(critical, displacement)
          if symbol < critical
            VariableTerm.new(symbol)
          else
            raise VariableExcepetion.new('FATAL: offset overflow') if symbol + displacement > 9
            VariableTerm.new(symbol + displacement)
          end
        end
      end

      class VariableExcepetion < Exception; end
    end
  end
end
