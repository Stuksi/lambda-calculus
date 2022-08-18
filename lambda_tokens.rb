module LambdaTokenizer
  class LambdaToken
    attr_reader :type, :symbol

    def initialize(type, symbol)
      @type = type
      @symbol = symbol
    end
  end

  class << self
    def tokenize_expression(expression)
      expression.chars.map do |character|
        case character
        when ' '      then next
        when '('      then LambdaToken.new(:open_bracket, '(')
        when ')'      then LambdaToken.new(:closed_bracket, ')')
        when '['      then LambdaToken.new(:open_square_bracket, '[')
        when ']'      then LambdaToken.new(:closed_square_bracket, ']')
        when '^'      then LambdaToken.new(:lambda, '^')
        when '.'      then LambdaToken.new(:dot, '.')
        when '-'      then LambdaToken.new(:dash, '-')
        when '>'      then LambdaToken.new(:arrow, '>')
        when 'a'..'z' then LambdaToken.new(:variable, character)
        else raise("FATAL: invalid token #{character}")
        end
      end.compact.push(LambdaToken.new(:end, '0'))
    end
  end
end

module LambdaTokensDebugger
  class << self
    def debug(tokens)
      puts 'DEBUG: Lambda Tokenizer Token'
      tokens.each { |token| puts "  #{token.type}, #{token.symbol}" }
      puts
    end
  end
end
