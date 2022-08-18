require_relative 'lambda_expressions'

# expression = '(^ab.ab)[a->^z.z](abcde)(^a.a)zz[z -> f]'
expression = '(aa(bb))^ab.zab[a->^a.z]'
parsed_expression = LambdaExpression.parse(expression)
puts parsed_expression.substitute
LambdaParsedExpressionDebugger.debug(parsed_expression)
