=begin
  Lambda Expression Grammar:
    Expression       := (NonBracketedTerm | BracketedTerm), [SubstitutionTerm], (Expression | "")
    BracketedTerm    := (, NonBracketedTerm, )
    NonBracketedTerm := LambdaTerm | VariableTerm
    SubstitutionTerm := [, VariableTerm, -, >, Expression, ]
    LambdaTerm       := ^, VariableTerm+, ., Expression
    VariableTerm     := a | ... | z
=end

require_relative 'lambda_tokens'

module Lambda
  private

  ACCEPTED_VARIABLE_SYMBOLS = ('a'..'z').to_a

  class NonBracketedTerm
    attr_reader :terms, :substitution

    def initialize(terms, substitution = nil)
      @terms = terms
      @substitution = substitution
    end

    def substitute(extended_substitution = nil)
      if substitution
        substituted_substitution = SubstitutionTerm.new(substitution.variable, substitution.term.substitute)
      end

      substituted_terms = terms.map { |term| term.substitute(substituted_substitution) }
      if extended_substitution
        substituted_terms.map! { |term| term.substitute(extended_substitution) }
      end

      self.class.new(substituted_terms)
    end

    def free_variables
      terms.map(&:free_variables).flatten
    end

    def to_s
      "#{terms.map(&:to_s).join}#{substitution}"
    end
  end

  class BracketedTerm < NonBracketedTerm
    def to_s
      "(#{terms.map(&:to_s).join})#{substitution}"
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
        unused_variable_symbols = ACCEPTED_VARIABLE_SYMBOLS - (free_variables_symbols | substitution_free_variable_symbols)

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

  class VariableTerm
    attr_reader :symbol

    def initialize(symbol)
      @symbol = symbol
    end

    def substitute(substitution)
      if substitution&.variable&.symbol === symbol
        substitution.term
      else
        VariableTerm.new(symbol)
      end
    end

    def free_variables
      [symbol]
    end

    def to_s
      "#{symbol}"
    end
  end

  class ParseException < Exception
  end

  class SubstitutionException < Exception
  end

  class << self
    def parse_term(tokens_iterator)
      return if tokens_iterator.peek.type === :end                   ||
                tokens_iterator.peek.type === :closed_bracket        ||
                tokens_iterator.peek.type === :closed_square_bracket

      term =
        if tokens_iterator.peek.type === :open_bracket
          parse_bracketed_term(tokens_iterator)
        elsif tokens_iterator.peek.type === :lambda
          parse_lambda_term(tokens_iterator)
        elsif tokens_iterator.peek.type === :variable
          parse_variable_term(tokens_iterator)
        else
          raise_parse_exception
        end

      [term, *parse_term(tokens_iterator)]
    end

    def parse_bracketed_term(tokens_iterator)
      raise_parse_exception unless tokens_iterator.next.type === :open_bracket
      terms = parse_term(tokens_iterator)

      raise_parse_exception unless tokens_iterator.next.type === :closed_bracket
      substitution = parse_substitution_term(tokens_iterator) if tokens_iterator.peek.type === :open_square_bracket

      BracketedTerm.new(terms, substitution)
    end

    def parse_substitution_term(tokens_iterator)
      raise_parse_exception unless tokens_iterator.next.type === :open_square_bracket
      variable = VariableTerm.new(tokens_iterator.next.symbol)

      raise_parse_exception unless tokens_iterator.next.type === :dash
      raise_parse_exception unless tokens_iterator.next.type === :arrow

      term = NonBracketedTerm.new(parse_term(tokens_iterator))
      raise_parse_exception unless tokens_iterator.next.type === :closed_square_bracket

      SubstitutionTerm.new(variable, term)
    end

    def parse_lambda_term(tokens_iterator)
      raise_parse_exception unless tokens_iterator.next.type === :lambda
      bound_variables = []
      while tokens_iterator.peek.type != :dot
        raise_parse_exception unless tokens_iterator.peek.type === :variable
        bound_variables << VariableTerm.new(tokens_iterator.next.symbol)
      end

      raise_parse_exception unless tokens_iterator.next.type === :dot
      term = NonBracketedTerm.new(parse_term(tokens_iterator))
      substitution = parse_substitution_term(tokens_iterator) if tokens_iterator.peek.type === :open_square_bracket

      NonBracketedTerm.new([LambdaTerm.new(bound_variables, term)], substitution)
    end

    def parse_variable_term(tokens_iterator)
      raise_parse_exception unless tokens_iterator.peek.type === :variable
      symbol = tokens_iterator.next.symbol
      substitution = parse_substitution_term(tokens_iterator) if tokens_iterator.peek.type === :open_square_bracket

      NonBracketedTerm.new([VariableTerm.new(symbol)], substitution)
    end

    def raise_parse_exception
      raise ParseException.new('FATAL: ivalid expression')
    end
  end
end

module Lambda
  class Expression < NonBracketedTerm
  end

  class << self
    def parse(expression)
      tokens = tokenize_expression(expression)
      tokens_iterator = tokens.to_enum

      Expression.new(parse_term(tokens_iterator))
    end
  end
end

module LambdaDebugger
  class << self
    def debug_expression(expression)
      puts 'DEBUG: Lambda Expression'
      puts expression
      puts
    end
  end
end
