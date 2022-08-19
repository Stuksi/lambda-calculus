require_relative 'variable_term'
require_relative 'substitution_term'

module Lambda
  module NamedExpression
    module Terms
      class LambdaTerm
        attr_reader :bound_variables, :term

        def initialize(bound_variables, term)
          @bound_variables = bound_variables
          @term = term
        end

        def substitute(substitution)
          substituted_term = term.substitute
          return LambdaTerm.new(bound_variables, substituted_term) unless substitution

          bound_variables_symbols = bound_variables.map(&:symbol)
          free_variables_symbols = substituted_term.free_variables
          substitution_variable_symbol = substitution.variable.symbol
          substitution_free_variable_symbols = substitution.term.free_variables

          if bound_variables_symbols.include?(substitution_variable_symbol)
            LambdaTerm.new(bound_variables, substituted_term)
          elsif !bound_variables_symbols.include?(substitution_variable_symbol)   &&
                (!free_variables_symbols.include?(substitution_variable_symbol)   ||
                substitution_free_variable_symbols & bound_variables_symbols === [])
            LambdaTerm.new(bound_variables, substituted_term.substitute(substitution))
          else
            problem_variable_symbols = substitution_free_variable_symbols & bound_variables_symbols
            unused_variable_symbols = VariableTerm::SYMBOLS - (free_variables_symbols | substitution_free_variable_symbols)

            if problem_variable_symbols.length > unused_variable_symbols.length
              raise SubstitutionException.new('FATAL: too many symbols already used')
            end

            rename_mapping = problem_variable_symbols.zip(unused_variable_symbols).to_h
            renamed_bound_variables = bound_variables_symbols.map do |symbol|
              if rename_mapping.key?(symbol)
                VariableTerm.new(rename_mapping[symbol])
              else
                VariableTerm.new(symbol)
              end
            end

            renamed_term = substituted_term
            rename_mapping.each do |current_symbol, renamed_symbol|
              renaming_substitution = SubstitutionTerm.new(VariableTerm.new(current_symbol), VariableTerm.new(renamed_symbol))
              renamed_term = renamed_term.substitute(renaming_substitution)
            end
            renamed_term = renamed_term.substitute(substitution)

            LambdaTerm.new(renamed_bound_variables, renamed_term)
          end
        end

        def free_variables
          term.free_variables
        end

        def to_s
          "^#{bound_variables.map(&:to_s).join}.#{term}"
        end
      end
    end
  end
end
