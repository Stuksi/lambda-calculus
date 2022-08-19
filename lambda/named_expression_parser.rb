=begin
  Named Lambda Expression Grammar:
    NamedExpression  := (NonBracketedTerm | BracketedTerm), [SubstitutionTerm], (NamedExpression | "")
    BracketedTerm    := (, NonBracketedTerm, )
    NonBracketedTerm := LambdaTerm | VariableTerm
    SubstitutionTerm := [, VariableTerm, -, >, NamedExpression, ]
    LambdaTerm       := ^, VariableTerm+, ., NamedExpression
    VariableTerm     := a | ... | z
=end

require_relative 'named_expression/named_expression'
require_relative 'named_expression/terms/bracketed_term'
require_relative 'named_expression/terms/lambda_term'
require_relative 'named_expression/terms/non_bracketed_term'
require_relative 'named_expression/terms/substitution_term'
require_relative 'named_expression/terms/variable_term'
require_relative 'named_expression/tokens/tokenizer'

module Lambda
  class NamedExpressionParser
    class << self
      def parse(expression)
        tokens = NamedExpression::Tokens::Tokenizer.tokenize_expression(expression)
        tokens_iterator = tokens.to_enum

        NamedExpression::NamedExpression.new(
          NamedExpression::Terms::NonBracketedTerm.new(parse_term(tokens_iterator))
        )
      end

      private

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

        NamedExpression::Terms::BracketedTerm.new(terms, substitution)
      end

      def parse_substitution_term(tokens_iterator)
        raise_parse_exception unless tokens_iterator.next.type === :open_square_bracket
        variable = NamedExpression::Terms::VariableTerm.new(tokens_iterator.next.symbol)

        raise_parse_exception unless tokens_iterator.next.type === :dash
        raise_parse_exception unless tokens_iterator.next.type === :arrow

        term = NamedExpression::Terms::NonBracketedTerm.new(parse_term(tokens_iterator))
        raise_parse_exception unless tokens_iterator.next.type === :closed_square_bracket

        NamedExpression::Terms::SubstitutionTerm.new(variable, term)
      end

      def parse_lambda_term(tokens_iterator)
        raise_parse_exception unless tokens_iterator.next.type === :lambda
        bound_variables = []
        while tokens_iterator.peek.type != :dot
          raise_parse_exception unless tokens_iterator.peek.type === :variable
          bound_variables << NamedExpression::Terms::VariableTerm.new(tokens_iterator.next.symbol)
        end

        raise_parse_exception unless tokens_iterator.next.type === :dot
        term = NamedExpression::Terms::NonBracketedTerm.new(parse_term(tokens_iterator))
        substitution = parse_substitution_term(tokens_iterator) if tokens_iterator.peek.type === :open_square_bracket

        NamedExpression::Terms::NonBracketedTerm.new([NamedExpression::Terms::LambdaTerm.new(bound_variables, term)], substitution)
      end

      def parse_variable_term(tokens_iterator)
        raise_parse_exception unless tokens_iterator.peek.type === :variable
        symbol = tokens_iterator.next.symbol
        substitution = parse_substitution_term(tokens_iterator) if tokens_iterator.peek.type === :open_square_bracket

        NamedExpression::Terms::NonBracketedTerm.new([NamedExpression::Terms::VariableTerm.new(symbol)], substitution)
      end

      def raise_parse_exception
        raise ParseException.new('FATAL: ivalid expression')
      end
    end
  end

  class ParseException < Exception; end
end
