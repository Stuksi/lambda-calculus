require_relative 'lambda/named_expression_parser'
require_relative 'lambda/nameless_expression_parser'
require_relative 'lambda/logger'

task :debug_named_expression do
  named_expression = '(^ab.ab)[a->^z.z](abcde)(^c.a)[a->c]zz[z -> f]'

  parsed_named_expression = Lambda::NamedExpressionParser.parse(named_expression)
  Lambda::Logger.log_named_expression(parsed_named_expression)

  substituted_named_expression = parsed_named_expression.substitute
  Lambda::Logger.log_named_expression(substituted_named_expression)
rescue Exception => exception
  Lambda::Logger.log_exception("#{exception}")
end

task :debug_nameless_expression do
  nameless_expression = '((^1)(^01))[0->^01]'

  parsed_nameless_expression = Lambda::NamelessExpressionParser.parse(nameless_expression)
  Lambda::Logger.log_nameless_expression(parsed_nameless_expression)

  substituted_nameless_expression = parsed_nameless_expression.substitute
  Lambda::Logger.log_nameless_expression(substituted_nameless_expression)
rescue Exception => exception
  Lambda::Logger.log_exception("#{exception}")
end

task :debug_named_to_nameless_expression_conversion do
  named_expression = '(^abcdef.cbadefzz)[a->^z.d](abcde)(^c.a)[a->c]zz[z -> f]'
  parsed_named_expression = Lambda::NamedExpressionParser.parse(named_expression)

  parsed_nameless_expression = parsed_named_expression.to_nameless
  Lambda::Logger.log_nameless_expression(parsed_nameless_expression)
  substituted_nameless_expression = parsed_nameless_expression.substitute
  Lambda::Logger.log_nameless_expression(substituted_nameless_expression)
end
