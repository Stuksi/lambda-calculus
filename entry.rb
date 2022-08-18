require_relative 'lambda_expressions'

begin
  expression = '(^ab.ab)[a->^z.z](abcde)(^c.a)[a->c]zz[z -> f]'
  parsed_expression = Lambda.parse(expression)
  LambdaDebugger.debug_expression(parsed_expression)
  substituted_expression = parsed_expression.substitute
  LambdaDebugger.debug_expression(substituted_expression)
rescue Exception => exception
  puts exception
end
