module Lambda
  private

  class Token
    attr_reader :type, :symbol

    def initialize(type, symbol)
      @type = type
      @symbol = symbol
    end
  end

  class TokenException < Exception
  end
end

module Lambda
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
        else raise TokenException.new("FATAL: invalid token #{character}")
        end
      end.compact.push(Token.new(:end, '0'))
    end
  end
end

module LambdaDebugger
  class << self
    def debug_tokens(tokens)
      puts 'DEBUG: Lambda Tokens'
      tokens.each { |token| puts "  #{token.type}, #{token.symbol}" }
      puts
    end
  end
end
