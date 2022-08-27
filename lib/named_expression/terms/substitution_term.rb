module Lambda
  module NamedExpression
    module Terms
      class SubstitutionTerm
        attr_reader :variable, :term

        def initialize(variable, term)
          @variable = variable
          @term = term
        end

        def to_nameless(context)
          NamelessExpression::Terms::SubstitutionTerm.new(
            variable.to_nameless(context, 0, {}),
            term.to_nameless(context, 0, {})
          )
        end

        def to_s
          "[#{variable}->#{term}]"
        end

        def ==(substitution_term)
          self.class == substitution_term.class &&
          self.variable == substitution_term.variable &&
          self.term == substitution_term.term
        end
      end

      class SubstitutionTermException < Exception; end
    end
  end
end
