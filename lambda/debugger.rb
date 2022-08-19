module Lambda
  class Debugger
    class << self
      def debug_named_expression(named_expression)
        puts 'DEBUG: Named Lambda Expression'
        puts "    #{named_expression}"
        puts
      end

      def debig_named_tokens(named_tokens)
        puts 'DEBUG: Named Lambda Token'
        named_tokens.each { |token| puts "    #{token.type}, #{token.symbol}" }
        puts
      end
    end
  end
end
