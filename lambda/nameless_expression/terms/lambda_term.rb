require_relative 'variable_term'
require_relative 'substitution_term'

module Lambda
  module NamelessExpression
    module Terms
      class LambdaTerm
        attr_reader :variables

        def initialize(variables)
          @variables = variables
        end

        def to_s
          "^#{variables.map(&:to_s).join}"
        end
      end
    end
  end
end
