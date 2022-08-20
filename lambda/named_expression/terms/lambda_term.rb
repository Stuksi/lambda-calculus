module Lambda
  module NamedExpression
    module Terms
      class LambdaTerm
        attr_reader :bound_variables, :term

        def initialize(bound_variables, term)
          @bound_variables = bound_variables
          @term = term
        end

        def substitute(substitution = nil)
          substituted_term = term.substitute
          return LambdaTerm.new(bound_variables, substituted_term) unless substitution

          substitution_free_variables = substitution.term.free_variables
          if bound_variables.include?(substitution.variable)
            LambdaTerm.new(bound_variables, substituted_term)
          elsif !bound_variables.include?(substitution.variable) &&
                (!free_variables.include?(substitution.variable) ||
                substitution_free_variables & bound_variables == [])
            LambdaTerm.new(bound_variables, substituted_term.substitute(substitution))
          else
            problem_variables = substitution_free_variables & bound_variables
            unused_variables = (VariableTerm::SYMBOLS - (free_variables.map(&:symbol) | substitution_free_variables.map(&:symbol))).map { |symbol| VariableTerm.new(symbol) }

            if problem_variables.length > unused_variables.length
              raise SubstitutionTermException.new('FATAL: too many symbols already used')
            end

            rename_mapping = problem_variables.zip(unused_variables).to_h
            renamed_bound_variables = bound_variables.map do |variable|
              if rename_mapping.key?(variable)
                rename_mapping[variable]
              else
                VariableTerm.new(variable.symbol)
              end
            end

            renamed_term = substituted_term
            rename_mapping.each do |current_variable, renamed_variable|
              renaming_substitution = SubstitutionTerm.new(current_variable, renamed_variable)
              renamed_term = renamed_term.substitute(renaming_substitution)
            end
            renamed_term = renamed_term.substitute(substitution)

            LambdaTerm.new(renamed_bound_variables, renamed_term)
          end
        end

        def to_nameless(lambdas, accumulated_bound_variables)
          bound_variables_lambda_mapping = bound_variables.map(&:symbol).map.with_index do |symbol, index|
            [symbol, lambdas + bound_variables.length - 1 - index]
          end.to_h

          nameless_term = term.to_nameless(
            lambdas + bound_variables.length,
            accumulated_bound_variables.merge(bound_variables_lambda_mapping)
          )

          nameless_lambda_term = NamelessExpression::Terms::NonBracketedTerm.new(
            [NamelessExpression::Terms::LambdaTerm.new(nameless_term)]
          )

          (bound_variables.length - 1).times do
            nameless_lambda_term = NamelessExpression::Terms::NonBracketedTerm.new(
              [NamelessExpression::Terms::LambdaTerm.new(nameless_lambda_term)]
            )
          end

          nameless_lambda_term
        end

        def free_variables(accumulated_bound_variables = [])
          term.free_variables(accumulated_bound_variables + bound_variables)
        end

        def to_s
          "^#{bound_variables.map(&:to_s).join}.#{term}"
        end

        def ==(lambda_term)
          self.class == lambda_term.class                     &&
          self.bound_variables == lambda_term.bound_variables &&
          self.term == lambda_term.term
        end
      end
    end
  end
end
