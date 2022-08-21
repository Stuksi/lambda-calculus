module Lambda
  module NamedExpression
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
              when '.'      then Token.new(:dot, '.')
              when '-'      then Token.new(:dash, '-')
              when '>'      then Token.new(:arrow, '>')
              when 'a'..'z' then Token.new(:variable, character)
              else raise TokenizerException.new("FATAL: invalid token #{character}")
              end
            end.compact.push(Token.new(:end, '|'))
          end
        end
      end

      class TokenizerException < Exception; end
    end
  end
end
