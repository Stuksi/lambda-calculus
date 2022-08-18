require_relative 'lambda_tokens'

module LambdaExpression
  class NonBracketedTerms
    attr_reader :terms, :substitution_term

    def initialize(terms, substitution_term = nil)
      @terms = terms
      @substitution_term = substitution_term
    end

    def substitute(passed_substitution_term = nil)
      substituted_terms = terms.map { |term| term.substitute(substitution_term) }
      substituted_terms = substituted_terms.map { |term| term.substitute(passed_substitution_term) } if passed_substitution_term
      substituted_terms
    end

    def free_variables
      terms.map(&:free_variables)
    end

    def to_s
      "#{terms.map(&:to_s).join}#{substitution_term}"
    end
  end

  class BracketedTerms < NonBracketedTerms
    def to_s
      "(" + super + ")"
    end
  end

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

  class LambdaTerm
    attr_reader :bound_variables, :term

    def initialize(bound_variables, term)
      @bound_variables = bound_variables
      @term = term
    end

    def substitute(substitution_term)
      bound_variables_symbols = bound_variables.map(&:symbol)
      free_variables_symbols = free_variables.map(&:symbol)
      substitution_term_variable_symbol = substitution_term.variable.symbol
      substitution_term_free_variable_symbols = substitution_term.term.free_variables.map(&:symbol)

      if bound_variables_symbols.include?(substitution_term_variable_symbol)
        self
      elsif (
        !bound_variables_symbols.include?(substitution_term_variable_symbol)   &&
        !free_variables_symbols.include?(substitution_term_variable_symbol)                    ||
        substitution_term_free_variable_symbols & bound_variables_symbols == nil
      )
        LambdaTerm.new(bound_variables, term.substitute(substitution_term))
      else
        problem_variable_symbols = substitution_term_free_variable_symbols & bound_variables_symbols
        unused_variable_symbols = ('a'..'z') - (free_variables_symbols | substitution_term_free_variable_symbols)
        raise 'FATAL: too many symbols already used' if problem_variable_symbols.length > unused_variable_symbols.length

        variable_symbols_mapping = problem_variable_symbols.zip(unused_variable_symbols).to_h
        renamed_bound_variables = bound_variables_symbols.map do |symbol|
          if variable_symbols_mapping.key?(symbol)
            VariableTerm.new(variable_symbols_mapping[symbol])
          else
            VariableTerm.new(symbol)
          end
        end

        renamed_term = term.clone
        variable_symbols_mapping.map do |current_symbol, renamed_symbol|
          renaming_substitution_term = SubstitutionTerm.new(
            VariableTerm.new(current_symbol),
            VariableTerm.new(renamed_symbol)
          )
          renamed_term.substitute(renaming_substitution_term)
        end

        renamed_term.substitute(substitution_term)
        LambdaTerm.new(renamed_bound_variables, renamed_term)
      end
    end

    def free_variables
      term.free_variables
    end

    def to_s
      stringlified_bound_variables = bound_variables.map(&:to_s).join

      "^#{stringlified_bound_variables}.#{term}"
    end
  end

  class VariableTerm
    attr_reader :symbol

    def initialize(symbol)
      @symbol = symbol
    end

    def substitute(substitution_term)
      return self.clone unless substitution_term
      puts substitution_term

      if symbol === substitution_term.variable.symbol
        substitution_term.term
      else
        self.clone
      end
    end

    def free_variables
      self.clone
    end

    def to_s
      symbol
    end
  end

  class << self
    def parse(expression)
      tokens = LambdaTokenizer.tokenize_expression(expression)
      tokens_iterator = tokens.to_enum

      NonBracketedTerms.new(parse_term(tokens_iterator))
    end

    private

    def parse_term(tokens_iterator)
      return if tokens_iterator.peek.type === :end                   ||
                tokens_iterator.peek.type === :closed_bracket        ||
                tokens_iterator.peek.type === :closed_square_bracket

      if tokens_iterator.peek.type === :open_bracket
        bracketed_terms = parse_bracketed_terms(tokens_iterator)
      else
        non_bracketed_term =
          if tokens_iterator.peek.type === :lambda
            parse_lambda_term(tokens_iterator)
          elsif tokens_iterator.peek.type === :variable
            parse_variable_term(tokens_iterator)
          else
            raise_invalid_type_error
          end
      end

      substitution_term = parse_substitution_term(tokens_iterator) if tokens_iterator.peek.type === :open_square_bracket
      [
        bracketed_terms ?
          BracketedTerms.new(bracketed_terms, substitution_term) :
          NonBracketedTerms.new([non_bracketed_term], substitution_term),
        *parse_term(tokens_iterator)
      ]
    end

    def parse_bracketed_terms(tokens_iterator)
      raise_invalid_type_error unless tokens_iterator.next.type === :open_bracket
      terms = parse_term(tokens_iterator)
      raise_invalid_type_error unless tokens_iterator.next.type === :closed_bracket

      terms
    end

    def parse_substitution_term(tokens_iterator)
      raise_invalid_type_error unless tokens_iterator.next.type === :open_square_bracket
      variable = parse_variable_term(tokens_iterator)
      raise_invalid_type_error unless tokens_iterator.next.type === :dash
      raise_invalid_type_error unless tokens_iterator.next.type === :arrow
      term = NonBracketedTerms.new(parse_term(tokens_iterator))
      raise_invalid_type_error unless tokens_iterator.next.type === :closed_square_bracket

      SubstitutionTerm.new(variable, term)
    end

    def parse_lambda_term(tokens_iterator)
      raise_invalid_type_error unless tokens_iterator.next.type === :lambda
      bound_variables = []
      while tokens_iterator.peek.type != :dot
        raise_invalid_type_error unless tokens_iterator.peek.type === :variable
        bound_variables << VariableTerm.new(tokens_iterator.next.symbol)
      end
      raise_invalid_type_error unless tokens_iterator.next.type === :dot
      term = NonBracketedTerms.new(parse_term(tokens_iterator))

      LambdaTerm.new(bound_variables, term)
    end

    def parse_variable_term(tokens_iterator)
      raise_invalid_type_error unless tokens_iterator.peek.type === :variable

      VariableTerm.new(tokens_iterator.next.symbol)
    end

    def raise_invalid_type_error
      raise 'FATAL: ivalid token type'
    end
  end
end

module LambdaParsedExpressionDebugger
  class << self
    def debug(parsed_expression)
      puts 'DEBUG: Lambda Expression Term'
      puts parsed_expression
      puts
    end
  end
end
