require_relative 'lambda/named_expression_parser'
require_relative 'lambda/debugger'

task :debug do
  expression = '(^ab.ab)[a->^z.z](abcde)(^c.a)[a->c]zz[z -> f]'
  parsed_expression = Lambda::NamedExpressionParser.parse(expression)
  Lambda::Debugger.debug_named_expression(parsed_expression)
  substituted_expression = parsed_expression.substitute
  Lambda::Debugger.debug_named_expression(substituted_expression)
rescue Exception => exception
  puts exception
end
