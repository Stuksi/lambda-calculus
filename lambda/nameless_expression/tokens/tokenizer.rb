require_relative 'token'

module Lambda
  module NamelessExpression
    module Tokens
      class Tokenizer
        class << self
          def tokenize_expression(expression)
            expression.chars.map do |character|
              case character
              when ' '      then next
              when '('      then Token.new(:open_bracket, '(')
              when ')'      then Token.new(:closed_bracket, ')')
              when '['      then Token.new(:open_square_bracket, '[')
              when ']'      then Token.new(:closed_square_bracket, ']')
              when '^'      then Token.new(:lambda, '^')
              when '-'      then Token.new(:dash, '-')
              when '>'      then Token.new(:arrow, '>')
              when '0'..'9' then Token.new(:variable, character)
              else raise NamelessExpressionTokenizerException.new("FATAL: invalid token #{character}")
              end
            end.compact.push(Token.new(:end, '0'))
          end
        end
      end

      class NamelessExpressionTokenizerException < Exception; end
    end
  end
end
