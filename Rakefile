require_relative 'environment'

task :debug do
  named_expression = '(^ab.ab)[a->^z.z](abcde)(^c.a)[a->c]zz[z -> f]'

  parsed_named_expression = Lambda::NamedExpressionParser.parse(named_expression)
  puts named_expression
  puts parsed_named_expression.to_nameless
  puts parsed_named_expression.to_nameless.to_named
end

task :debug_named_expression do
  named_expression = '(^ab.ab)[a->^z.z](abcde)(^c.a)[a->c]zz[z -> f]'

  parsed_named_expression = Lambda::NamedExpressionParser.parse(named_expression)
  puts parsed_named_expression

  substituted_named_expression = parsed_named_expression.substitute
  puts substituted_named_expression
end

task :debug_nameless_expression do
  nameless_expression = '((^1)(^01))[0->^01]'

  parsed_nameless_expression = Lambda::NamelessExpressionParser.parse(nameless_expression)
  puts parsed_nameless_expression

  substituted_nameless_expression = parsed_nameless_expression.substitute
  puts substituted_nameless_expression
end

task :debug_named_to_nameless_expression_conversion do
  named_expression = '(^abcdef.cbadefzz)[a->^z.d](abcde)(^c.a)[a->c]zz[z -> f]'
  parsed_named_expression = Lambda::NamedExpressionParser.parse(named_expression)

  parsed_nameless_expression = parsed_named_expression.to_nameless
  puts parsed_nameless_expression
end

task :debug_nameless_to_named_expression_conversion do
  nameless_expression = '(^^^^^^34521066)(12345)(^4)06'
  parsed_nameless_expression = Lambda::NamelessExpressionParser.parse(nameless_expression)

  parsed_named_expression = parsed_nameless_expression.to_named
  puts parsed_named_expression
end
