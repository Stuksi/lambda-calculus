module Lambda
  module NamedExpression
    module Tokens
      class Token
        attr_reader :type, :symbol

        def initialize(type, symbol)
          @type = type
          @symbol = symbol
        end
      end
    end
  end
end
