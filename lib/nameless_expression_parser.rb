module Lambda
  class NamelessExpressionParser
    class << self
      def parse(expression)
        tokens = NamelessExpression::Tokens::Tokenizer.tokenize_expression(expression)
        tokens_iterator = tokens.to_enum

        NamelessExpression::NamelessExpression.new(
          NamelessExpression::Terms::NonBracketedTerm.new(parse_term(tokens_iterator))
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

        NamelessExpression::Terms::BracketedTerm.new(terms, substitution)
      end

      def parse_substitution_term(tokens_iterator)
        raise_parse_exception unless tokens_iterator.next.type === :open_square_bracket
        variable = NamelessExpression::Terms::VariableTerm.new(tokens_iterator.next.symbol.to_i)

        raise_parse_exception unless tokens_iterator.next.type === :dash
        raise_parse_exception unless tokens_iterator.next.type === :arrow

        term = NamelessExpression::Terms::NonBracketedTerm.new(parse_term(tokens_iterator))
        raise_parse_exception unless tokens_iterator.next.type === :closed_square_bracket

        NamelessExpression::Terms::SubstitutionTerm.new(variable, term)
      end

      def parse_lambda_term(tokens_iterator)
        raise_parse_exception unless tokens_iterator.next.type === :lambda
        term = NamelessExpression::Terms::NonBracketedTerm.new(parse_term(tokens_iterator))

        NamelessExpression::Terms::LambdaTerm.new(term)
      end

      def parse_variable_term(tokens_iterator)
        raise_parse_exception unless tokens_iterator.peek.type === :variable
        symbol = tokens_iterator.next.symbol
        substitution = parse_substitution_term(tokens_iterator) if tokens_iterator.peek.type === :open_square_bracket

        NamelessExpression::Terms::NonBracketedTerm.new(
          [NamelessExpression::Terms::VariableTerm.new(symbol.to_i)],
          substitution
        )
      end

      def raise_parse_exception
        raise ParserException.new('FATAL: ivalid expression')
      end
    end
  end
end
