require 'logger'

module Lambda
  class Logger
    LOGGER = ::Logger.new(STDOUT)

    class << self
      def log_named_tokens(named_tokens)
        LOGGER.info("Logging Named Tokens")
        named_tokens.each { |token| LOGGER.debug("    #{token.type}, #{token.symbol}") }
      end

      def log_named_expression(named_expression)
        LOGGER.info("Logging Named Expression")
        LOGGER.debug("#{named_expression}")
      end

      def log_nameless_expression(nameless_expression)
        LOGGER.info("Logging Nameless Expression")
        LOGGER.debug("#{nameless_expression}")
      end

      def log_exception(exception)
        LOGGER.fatal("#{exception}")
      end
    end
  end
end
