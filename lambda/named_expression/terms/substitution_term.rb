module Lambda
  module NamedExpression
    module Terms
      class SubstitutionTerm
        attr_reader :variable, :term

        def initialize(variable, term)
          @variable = variable
          @term = term
        end

        def to_s
          "[#{variable}->#{term}]"
        end
      end

      class SubstitutionException < Exception; end
    end
  end
end
